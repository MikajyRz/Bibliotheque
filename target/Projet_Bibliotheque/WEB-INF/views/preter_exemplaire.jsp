<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prêter un exemplaire</title>
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

        select, input[type="date"] {
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

        .success-message {
            background-color: #f9f9f9;
            color: #2c1810;
            padding: 10px;
            margin-bottom: 1rem;
            border: 1px solid #8B4513;
            border-radius: 4px;
            text-align: center;
        }

        .error-message {
            background-color: #2c1810;
            color: white;
            padding: 10px;
            margin-bottom: 1rem;
            border: 1px solid #000000;
            border-radius: 4px;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            margin: 1rem 0;
            padding: 10px 20px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            border: 2px solid #2c1810;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
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
            
            .form-group {
                flex-direction: column;
                align-items: flex-start;
            }
            
            label {
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            select, input[type="date"] {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            select, input[type="date"], button {
                padding: 8px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/bibliothecaires/accueil" class="back-link">Retour à l'accueil</a>
    <h2>Prêter un exemplaire</h2>
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
</body>
</html>