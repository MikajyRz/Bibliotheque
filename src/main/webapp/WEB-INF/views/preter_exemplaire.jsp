<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prêter un exemplaire</title>
</head>
<body>
<h2>Prêter un exemplaire</h2>
<form action="${pageContext.request.contextPath}/prets/nouveau" method="post">
    <label for="idAdherent">Adhérent :</label>
    <select name="idAdherent" id="idAdherent" required>
        <option value="">Sélectionner un adhérent</option>
        <c:forEach items="${adherents}" var="adherent">
            <option value="${adherent.id_adherent}">${adherent.nom} (${adherent.email})</option>
        </c:forEach>
    </select><br/><br/>

    <label for="idExemplaire">Exemplaire :</label>
    <select name="idExemplaire" id="idExemplaire" required>
        <option value="">Sélectionner un exemplaire</option>
        <c:forEach items="${exemplaires}" var="exemplaire">
            <option value="${exemplaire.id_exemplaire}">
                #${exemplaire.id_exemplaire} (${exemplaire.livre.titre})
            </option>
        </c:forEach>
    </select><br/><br/>

    <label for="idTypePret">Type de prêt :</label>
    <select name="idTypePret" id="idTypePret" required>
        <option value="">Sélectionner un type de prêt</option>
        <c:forEach items="${typesPret}" var="typePret">
            <option value="${typePret.id_type_pret}">${typePret.libelle}</option>
        </c:forEach>
    </select><br/><br/>

    <button type="submit">Valider le prêt</button>
</form>
</body>
</html>