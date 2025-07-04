<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Connexion - Bibliothèque</title>
    <style>
        body { font-family: 'Georgia', serif; background: #f5f1ea; color: #333; margin: 0; padding: 0; }
        h2 { text-align: center; color: #5a3e1b; margin-top: 40px; }
        .form-container { background-color: #ffffffcc; width: 400px; margin: 40px auto; padding: 30px 40px; border-radius: 10px; box-shadow: 0 0 15px rgba(0,0,0,0.2);}
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #4a3424;}
        input[type="text"], input[type="password"], input[type="email"] { width: 100%; padding: 8px; border: 1px solid #b79e85; border-radius: 5px; background-color: #fefdfb;}
        button { width: 100%; padding: 10px; background-color: #7b5e3b; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer;}
        button:hover { background-color: #5c4529;}
        .message { text-align: center; margin-bottom: 10px;}
        .message.error { color: #d9534f;}
        .message.success { color: #5cb85c;}
    </style>
</head>
<body>
<h2>Connexion</h2>

<div class="form-container">
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/auth/login" method="post">
        <div>
            <label for="email">Email :</label>
            <input type="email" id="email" name="email" required/>
        </div>
        <div>
            <label for="motDePasse">Mot de passe :</label>
            <input type="password" id="motDePasse" name="motDePasse" required/>
        </div>
        <div>
            <button type="submit">Se connecter</button>
        </div>
    </form>
</div>
</body>
</html>