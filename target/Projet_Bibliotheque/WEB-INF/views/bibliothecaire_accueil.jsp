<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Bibliothécaire</title>
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
            padding: 5px;
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

        .return-form input[type="submit"][value="Prolonger"] {
            background: linear-gradient(135deg, #4682B4 0%, #2F4F4F 100%);
        }

        .return-form input[type="submit"][value="Prolonger"]:hover {
            background: linear-gradient(135deg, #2F4F4F 0%, #1C2526 100%);
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
    <h2>Bienvenue, ${userName}</h2>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/prets/nouveau/accueil?section=pret">Prêter un exemplaire</a>
        <a href="${pageContext.request.contextPath}/prets/historique/accueil?section=historique">Historique des prêts</a>
        <a href="${pageContext.request.contextPath}/prets/recherche?section=recherche">Recherche des prêts</a>
        <a href="${pageContext.request.contextPath}/auth/logout">Déconnexion</a>
    </div>

    <c:if test="${section == 'pret'}">
        <h2>Prêter un exemplaire</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
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
                <input type="date" name="datePret" id="datePret"/>
            </div>
            <div class="form-group">
                <input type="submit" value="Valider le prêt"/>
            </div>
        </form>
    </c:if>

    <c:if test="${section == 'historique'}">
        <h2>Historique des prêts</h2>
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
                                    <fmt:formatDate value="${pret.dateRetourReelle}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>Non retourné</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </fmt:timeZone>
        </table>
    </c:if>

    <c:if test="${section == 'recherche'}">
        <h2>Recherche multicritère des prêts</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/prets/recherche" method="post">
            <div class="form-group">
                <label for="adherent">Adhérent (nom ou email) :</label>
                <input type="text" name="adherent" id="adherent" value="${param.adherent}"/>
            </div>
            <div class="form-group">
                <label for="exemplaire">Exemplaire (titre ou ID) :</label>
                <input type="text" name="exemplaire" id="exemplaire" value="${param.exemplaire}"/>
            </div>
            <div class="form-group">
                <label for="idTypePret">Type de prêt :</label>
                <select name="idTypePret" id="idTypePret">
                    <option value="">Tous</option>
                    <c:forEach items="${typesPret}" var="typePret">
                        <option value="${typePret.id_type_pret}" ${param.idTypePret == typePret.id_type_pret ? 'selected' : ''}>${typePret.libelle}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="dateDebut">Date de prêt (début) :</label>
                <input type="date" name="dateDebut" id="dateDebut" value="${param.dateDebut}"/>
            </div>
            <div class="form-group">
                <label for="dateFin">Date de prêt (fin) :</label>
                <input type="date" name="dateFin" id="dateFin" value="${param.dateFin}"/>
            </div>
            <div class="form-group">
                <input type="submit" value="Rechercher"/>
            </div>
        </form>

        <c:if test="${not empty searchResults}">
            <h2>Résultats de la recherche</h2>
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
                            <th>Actions</th>
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
                                    <td>
                                        <c:if test="${empty pret.dateRetourReelle}">
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
                                            <c:if test="${pret.nbProlongements < pret.adherent.typeAdherent.nbJourMaxProlongement && pret.typePret.id_type_pret != 2}">
                                                <form action="${pageContext.request.contextPath}/prets/prolonger" method="post" class="return-form">
                                                    <input type="hidden" name="idPret" value="${pret.id_pret}"/>
                                                    <input type="hidden" name="adherent" value="${param.adherent}"/>
                                                    <input type="hidden" name="exemplaire" value="${param.exemplaire}"/>
                                                    <input type="hidden" name="idTypePret" value="${param.idTypePret}"/>
                                                    <input type="hidden" name="dateDebut" value="${param.dateDebut}"/>
                                                    <input type="hidden" name="dateFin" value="${param.dateFin}"/>
                                                    <input type="date" name="dateProlongement" required/>
                                                    <input type="submit" value="Prolonger"/>
                                                </form>
                                            </c:if>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </fmt:timeZone>
                    </table>
                </c:otherwise>
            </c:choose>
        </c:if>
    </c:if>
</div>
</body>
</html>