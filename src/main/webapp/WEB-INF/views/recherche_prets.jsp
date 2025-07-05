
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Résultats de recherche des prêts</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Georgia', serif;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background-color: #ffffff;
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            border: 2px solid #8B4513;
        }

        h2 {
            text-align: center;
            color: #2c1810;
            margin-bottom: 2rem;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .navbar {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 2rem;
        }

        .navbar a {
            padding: 10px 20px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            border: 2px solid #2c1810;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            border: 1px solid #8B4513;
            padding: 10px;
            text-align: left;
        }

        th {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            font-weight: 500;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f0e6d6;
        }

        .no-results, .message {
            text-align: center;
            color: #2c1810;
            font-style: italic;
            margin-top: 1rem;
        }

        .success-message {
            color: green;
        }

        .error-message {
            color: red;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2c1810;
        }

        .form-group select, .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #8B4513;
            border-radius: 4px;
            font-size: 1rem;
        }

        .form-group input[type="submit"] {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            border: 2px solid #2c1810;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .form-group input[type="submit"]:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
        }

        .return-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .return-form input[type="date"] {
            padding: 5 Portfoliopx;
            border: 1px solid #8B4513;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .return-form input[type="submit"] {
            padding: 5px 10px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            border: 2px solid #2c1810;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .return-form input[type="submit"]:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-1px);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 1.5rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .navbar {
                flex-direction: column;
                gap: 10px;
            }

            th, td {
                padding: 8px;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }

            h2 {
                font-size: 1.3rem;
            }

            table {
                font-size: 0.85rem;
            }

            th, td {
                padding: 6px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Résultats de recherche des prêts</h2>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/prets/nouveau/accueil?section=pret">Prêter un exemplaire</a>
        <a href="${pageContext.request.contextPath}/prets/historique/accueil?section=historique">Historique des prêts</a>
        <a href="${pageContext.request.contextPath}/prets/recherche?section=recherche">Recherche des prêts</a>
        <a href="${pageContext.request.contextPath}/auth/logout">Déconnexion</a>
    </div>
    <c:if test="${not empty successMessage}">
        <p class="message success-message">${successMessage}</p>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <p class="message error-message">${errorMessage}</p>
    </c:if>
    <c:choose>
        <c:when test="${empty prets}">
            <p class="no-results">Aucun prêt trouvé pour ces critères.</p>
        </c:when>
        <c:otherwise>
            <table>
                <tr>
                    <th>ID Prêt</th>
                    <th>Adhérent</th>
                    <th>Exemplaire</th>
                    <th>Type de prêt</th>
                    <th>Date de prêt</th>
                    <th>Date de retour prévue</th>
                    <th>Date de retour réelle</th>
                </tr>
                <fmt:timeZone value="EAT">
                    <c:forEach items="${prets}" var="pret">
                        <tr>
                            <td>${pret.id_pret}</td>
                            <td>${pret.adherent.nom}</td>
                            <td>#${pret.exemplaire.id_exemplaire} (${pret.exemplaire.livre.titre})</td>
                            <td>${pret.typePret.libelle}</td>
                            <td><fmt:formatDate value="${pret.datePret}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${pret.dateRetourPrevue}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty pret.dateRetourReelle}">
                                        <fmt:formatDate value="${pret.dateRetourReelle}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/prets/retour" method="post" class="return-form">
                                            <input type="hidden" name="idAdherent" value="${pret.adherent.id_adherent}"/>
                                            <input type="hidden" name="idExemplaire" value="${pret.exemplaire.id_exemplaire}"/>
                                            <input type="hidden" name="adherent" value="${param.adherent}"/>
                                            <input type="hidden" name="exemplaire" value="${param.exemplaire}"/>
                                            <input type="hidden" name="idTypePret" value="${param.idTypePret}"/>
                                            <input type="hidden" name="dateDebut" value="${param.dateDebut}"/>
                                            <input type="hidden" name="dateFin" value="${param.dateFin}"/>
                                            <input type="date" name="dateRetour" required/>
                                            <input type="submit" value="Retourner"/>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </fmt:timeZone>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>