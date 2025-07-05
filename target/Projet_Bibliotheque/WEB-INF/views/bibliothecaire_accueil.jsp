<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Bibliothécaire - Bibliothèque</title>
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

        h2, h3 {
            text-align: center;
            color: #2c1810;
            margin-bottom: 2rem;
            font-size: 1.8rem;
            font-weight: 600;
        }

        h3 {
            font-size: 1.4rem;
            margin-top: 2rem;
        }

        .navbar {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .navbar a {
            color: #ffffff;
            text-decoration: none;
            padding: 10px 20px;
            background: transparent;
            border: 2px solid #2c1810;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        .search-form, .pret-form {
            margin-top: 2rem;
            padding: 1.5rem;
            background-color: #f9f9f9;
            border-radius: 8px;
            border: 1px solid #8B4513;
        }

        .form-group {
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        label {
            display: inline-block;
            width: 150px;
            font-weight: bold;
            color: #2c1810;
        }

        input[type="text"], input[type="date"], select {
            padding: 8px;
            width: calc(100% - 160px);
            border: 1px solid #8B4513;
            border-radius: 4px;
            font-size: 1rem;
        }

        button {
            padding: 10px 20px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        button:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
        }

        .success-message, .error-message {
            padding: 10px;
            margin-bottom: 1rem;
            border-radius: 4px;
            text-align: center;
        }

        .success-message {
            background-color: #f9f9f9;
            color: #2c1810;
            border: 1px solid #8B4513;
        }

        .error-message {
            background-color: #2c1810;
            color: white;
            border: 1px solid #000000;
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

        .no-results {
            text-align: center;
            color: #2c1810;
            font-style: italic;
            margin-top: 1rem;
        }

        .logout {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #8B4513;
        }

        .logout a {
            background: linear-gradient(135deg, #2c1810 0%, #000000 100%);
            color: white;
            border-color: #000000;
            width: auto;
            min-width: 150px;
            padding: 10px 20px;
        }

        .logout a:hover {
            background: linear-gradient(135deg, #000000 0%, #2c1810 100%);
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .navbar {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .navbar a {
                width: 100%;
                text-align: center;
            }
            
            .form-group {
                flex-direction: column;
                align-items: flex-start;
            }
            
            label {
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            input[type="text"], input[type="date"], select {
                width: 100%;
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
            
            .navbar a, button {
                padding: 8px 16px;
                font-size: 0.9rem;
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
    <h2>Bienvenue, <c:out value="${userName}"/></h2>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/prets/nouveau/accueil">Prêter un exemplaire</a>
        <a href="${pageContext.request.contextPath}/prets/historique/accueil">Historique des prêts</a>
        <a href="${pageContext.request.contextPath}/prets/recherche">Recherche des prêts</a>
    </nav>
    <c:if test="${showPretForm}">
        <div class="pret-form">
            <h3>Prêter un exemplaire</h3>
            <c:if test="${not empty successMessage}">
                <div class="success-message">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/prets/nouveau" method="post">
                <div class="form-group">
                    <label for="idAdherent">Adhérent :</label>
                    <select name="idAdherent" id="idAdherent" required>
                        <option value="">Sélectionner un adhérent</option>
                        <c:forEach items="${adherents}" var="adherent">
                            <option value="${adherent.id_adherent}">${adherent.nom} (${adherent.email})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="idExemplaire">Exemplaire :</label>
                    <select name="idExemplaire" id="idExemplaire" required>
                        <option value="">Sélectionner un exemplaire</option>
                        <c:forEach items="${exemplaires}" var="exemplaire">
                            <option value="${exemplaire.id_exemplaire}">#${exemplaire.id_exemplaire} (${exemplaire.livre.titre})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="idTypePret">Type de prêt :</label>
                    <select name="idTypePret" id="idTypePret" required>
                        <option value="">Sélectionner un type de prêt</option>
                        <c:forEach items="${typesPret}" var="typePret">
                            <option value="${typePret.id_type_pret}">${typePret.libelle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="datePret">Date de prêt :</label>
                    <input type="date" name="datePret" id="datePret">
                </div>
                <button type="submit">Valider le prêt</button>
            </form>
        </div>
    </c:if>
    <c:if test="${not empty prets}">
        <h3>Historique des prêts</h3>
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
                                <c:otherwise>Non retourné</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </fmt:timeZone>
        </table>
    </c:if>
    <div class="search-form">
        <h3>Recherche multicritère des prêts</h3>
        <c:if test="${not empty searchResults}">
            <h3>Résultats de la recherche</h3>
            <c:choose>
                <c:when test="${empty searchResults}">
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
                            <c:forEach items="${searchResults}" var="pret">
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
                                            <c:otherwise>Non retourné</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </fmt:timeZone>
                    </table>
                </c:otherwise>
            </c:choose>
        </c:if>
        <form action="${pageContext.request.contextPath}/prets/recherche" method="post">
            <div class="form-group">
                <label for="adherent">Adhérent (nom ou email) :</label>
                <input type="text" name="adherent" id="adherent" placeholder="Ex: Marie Curie ou marie@example.com">
            </div>
            <div class="form-group">
                <label for="exemplaire">Exemplaire (titre ou ID) :</label>
                <input type="text" name="exemplaire" id="exemplaire" placeholder="Ex: Les Misérables ou 5">
            </div>
            <div class="form-group">
                <label for="idTypePret">Type de prêt :</label>
                <select name="idTypePret" id="idTypePret">
                    <option value="">Tous</option>
                    <c:forEach items="${typesPret}" var="typePret">
                        <option value="${typePret.id_type_pret}">${typePret.libelle}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="dateDebut">Date de prêt (début) :</label>
                <input type="date" name="dateDebut" id="dateDebut">
            </div>
            <div class="form-group">
                <label for="dateFin">Date de prêt (fin) :</label>
                <input type="date" name="dateFin" id="dateFin">
            </div>
            <button type="submit">Rechercher</button>
        </form>
    </div>
    <div class="logout">
        <a href="${pageContext.request.contextPath}/">Déconnexion</a>
    </div>
</div>
</body>
</html>