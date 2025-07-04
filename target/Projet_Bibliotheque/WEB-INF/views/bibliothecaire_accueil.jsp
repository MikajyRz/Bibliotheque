<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Bibliothécaire - Bibliothèque</title>
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
    <h3>Historique des emprunts</h3>
    <table>
        <thead>
            <tr>
                <th>Adhérent</th>
                <th>Titre du livre</th>
                <th>Exemplaire</th>
                <th>Date de prêt</th>
                <th>Date de retour prévue</th>
                <th>Date de retour réelle</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="pret" items="${prets}">
                <tr>
                    <td><c:out value="${pret.adherent.nom}"/></td>
                    <td><c:out value="${pret.exemplaire.livre.titre}"/></td>
                    <td><c:out value="${pret.exemplaire.id_exemplaire}"/></td>
                    <td><c:out value="${pret.datePret}"/></td>
                    <td><c:out value="${pret.dateRetourPrevue}"/></td>
                    <td><c:out value="${pret.dateRetourReelle != null ? pret.dateRetourReelle : 'Non retourné'}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="form-container">
        <h3>Filtrer les prêts</h3>
        <form action="${pageContext.request.contextPath}/bibliothecaires/accueil" method="get">
            <div>
                <label for="idAdherent">ID Adhérent (optionnel) :</label>
                <input type="text" id="idAdherent" name="idAdherent"/>
            </div>
            <div>
                <label for="enCoursSeulement">Prêts en cours uniquement :</label>
                <input type="checkbox" id="enCoursSeulement" name="enCoursSeulement" value="true"/>
            </div>
            <div>
                <button type="submit">Filtrer</button>
            </div>
        </form>
    </div>
    <p><a href="${pageContext.request.contextPath}/">Déconnexion</a></p>
    <a href="${pageContext.request.contextPath}/prets/nouveau">Prêter un exemplaire</a>
</div>
</body>
</html>