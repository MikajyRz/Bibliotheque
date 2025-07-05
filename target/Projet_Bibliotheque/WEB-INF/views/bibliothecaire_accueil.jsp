<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            max-width: 800px;
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

        ul {
            list-style: none;
            margin-bottom: 2rem;
        }

        li {
            margin-bottom: 1rem;
        }

        a {
            display: inline-block;
            color: #ffffff;
            text-decoration: none;
            padding: 12px 24px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            border-radius: 8px;
            border: 2px solid #2c1810;
            transition: all 0.3s ease;
            font-weight: 500;
            width: 100%;
            text-align: center;
        }

        a:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
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
        }

        .logout a:hover {
            background: linear-gradient(135deg, #000000 0%, #2c1810 100%);
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
            
            a {
                padding: 14px 20px;
                font-size: 0.95rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            a {
                padding: 12px 16px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Bienvenue, <c:out value="${userName}"/></h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/prets/nouveau">Prêter un exemplaire</a></li>
        <li><a href="${pageContext.request.contextPath}/prets/historique">Historique des prêts</a></li>
    </ul>
    <div class="logout">
        <a href="${pageContext.request.contextPath}/">Déconnexion</a>
    </div>
</div>
</body>
</html>