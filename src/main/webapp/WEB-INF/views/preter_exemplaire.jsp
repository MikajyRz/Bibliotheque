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
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            border: 2px solid #8B4513;
        }

        h2 {
            color: #2c1810;
            margin-bottom: 2rem;
            font-size: 1.8rem;
            font-weight: 600;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c1810;
            font-size: 1rem;
        }

        select, input[type="date"] {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #8B4513;
            border-radius: 8px;
            background: white;
            color: #2c1810;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        select:focus, input[type="date"]:focus {
            outline: none;
            border-color: #2c1810;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        select:hover, input[type="date"]:hover {
            border-color: #654321;
        }

        button {
            width: 100%;
            padding: 14px 24px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        button:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        button:active {
            transform: translateY(0);
        }

        .success-message {
            background: linear-gradient(135deg, #f8f5f0 0%, #e8dcc6 100%);
            color: #2c1810;
            padding: 16px;
            margin-bottom: 1.5rem;
            border: 2px solid #8B4513;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
        }

        .error-message {
            background: linear-gradient(135deg, #2c1810 0%, #000000 100%);
            color: white;
            padding: 16px;
            margin-bottom: 1.5rem;
            border: 2px solid #000000;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 2rem;
            padding: 10px 20px;
            background: linear-gradient(135deg, #2c1810 0%, #000000 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid #000000;
        }

        .back-link:hover {
            background: linear-gradient(135deg, #000000 0%, #2c1810 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
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
                margin-bottom: 1.5rem;
            }
            
            select, input[type="date"] {
                padding: 10px 14px;
                font-size: 0.95rem;
            }
            
            button {
                padding: 12px 20px;
                font-size: 1rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            select, input[type="date"] {
                padding: 8px 12px;
                font-size: 0.9rem;
            }
            
            button {
                padding: 10px 16px;
                font-size: 0.95rem;
            }
            
            .back-link {
                padding: 8px 16px;
                font-size: 0.9rem;
            }
        }

        /* Amélioration pour les sélecteurs sur mobile */
        @media (max-width: 480px) {
            select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23654321' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 12px center;
                background-repeat: no-repeat;
                background-size: 16px;
                padding-right: 40px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/bibliothecaires/accueil" class="back-link">← Retour à l'accueil</a>
    
    <h2>Prêter un exemplaire</h2>

    <!-- Afficher le message de succès -->
    <c:if test="${not empty successMessage}">
        <div class="success-message">${successMessage}</div>
    </c:if>

    <!-- Afficher le message d'erreur -->
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
                    <option value="${exemplaire.id_exemplaire}">
                        #${exemplaire.id_exemplaire} (${exemplaire.livre.titre})
                    </option>
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