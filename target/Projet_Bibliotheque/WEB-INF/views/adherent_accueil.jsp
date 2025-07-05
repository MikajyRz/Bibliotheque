<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Adhérent - Bibliothèque</title>
    <style>
        body {
            font-family: 'Georgia', serif;
            background: #f5f1ea url('https://www.transparenttextures.com/patterns/wood-pattern.png') repeat;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #5a3e1b;
            margin-top: 40px;
        }

        .container {
            background-color: #ffffffcc;
            width: 80%;
            margin: 40px auto;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }

        .message {
            text-align: center;
            margin-bottom: 10px;
        }

        .message.error {
            color: #d9534f;
        }

        .message.success {
            color: #5cb85c;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #b79e85;
            text-align: left;
        }

        th {
            background-color: #7b5e3b;
            color: white;
        }

        td {
            background-color: #fefdfb;
        }

        button {
            padding: 8px 12px;
            background-color: #7b5e3b;
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background-color: #5c4529;
        }

        a {
            color: #5a3e1b;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Bienvenue, <c:out value="${userName}"/></h2>
    <c:if test="${not empty error}">
        <div class="message error"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="message success"><c:out value="${success}"/></div>
    </c:if>
    <h3>Liste des livres</h3>
    <table>
        <thead>
            <tr>
                <th>Titre</th>
                <th>ISBN</th>
                <th>Type</th>
                <th>Édition</th>
                <th>Auteur</th>
                <th>Âge minimum</th>
                <th>Année de publication</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="livre" items="${livres}">
                <tr>
                    <td><c:out value="${livre.titre}"/></td>
                    <td><c:out value="${livre.isbn}"/></td>
                    <td><c:out value="${livre.typeLivre.libelle}"/></td>
                    <td><c:out value="${livre.edition}"/></td>
                    <td><c:out value="${livre.auteur.nom}"/></td>
                    <td><c:out value="${livre.ageMinimum}"/></td>
                    <td><c:out value="${livre.anneePublication}"/></td>
                    <td>
                        <c:set var="hasAvailable" value="false"/>
                        <c:forEach var="exemp" items="${exemplaires}">
                            <c:if test="${exemp.livre.id_livre == livre.id_livre && statutsExemplaires[exemp.id_exemplaire] == 'Disponible'}">
                                <form action="${pageContext.request.contextPath}/adherent/emprunter" method="post" style="display:inline;">
                                    <input type="hidden" name="idExemplaire" value="${exemp.id_exemplaire}"/>
                                    <input type="hidden" name="idTypePret" value="1"/>
                                    <button type="submit">Prêter #${exemp.id_exemplaire}</button>
                                </form>
                                <!-- Formulaire de réservation pour l'exemplaire -->
                                <form action="${pageContext.request.contextPath}/adherent/reserver" method="post" style="display:inline;">
                                    <input type="hidden" name="idExemplaire" value="${exemp.id_exemplaire}"/>
                                    <label for="dateReservation_${exemp.id_exemplaire}" style="font-size:0.9em;">Date :</label>
                                    <input type="date" id="dateReservation_${exemp.id_exemplaire}" name="dateReservation" required style="font-size:0.9em;"/>
                                    <button type="submit" style="margin-left:5px;">Réserver #${exemp.id_exemplaire}</button>
                                </form>
                                <c:set var="hasAvailable" value="true"/>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!hasAvailable}">
                            <span style="color:#c77">Aucun exemplaire disponible</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <p><a href="${pageContext.request.contextPath}/">Déconnexion</a></p>
</div>
</body>
</html>