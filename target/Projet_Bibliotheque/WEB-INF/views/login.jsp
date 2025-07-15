<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Bibliothèque Municipale</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #8B4513 0%, #654321 50%, #2c1810 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
        }

        /* Effet de texture subtile en arrière-plan */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(circle at 20% 80%, rgba(255,255,255,0.05) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255,255,255,0.05) 0%, transparent 50%);
            pointer-events: none;
        }

        .login-container {
            background: #ffffff;
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.4);
            border: 3px solid #8B4513;
            position: relative;
            z-index: 1;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 32px;
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
            border: 2px solid #2c1810;
        }

        .login-header h2 {
            color: #2c1810;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .login-header p {
            color: #654321;
            font-size: 1rem;
            font-weight: 500;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c1810;
            font-size: 0.95rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            z-index: 2;
        }

        .input-wrapper.email::before {
            content: '📧';
            font-size: 16px;
        }

        .input-wrapper.password::before {
            content: '🔒';
            font-size: 16px;
        }

        input[type="email"], 
        input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #ddd;
            border-radius: 8px;
            background: #fafafa;
            color: #333;
            font-size: 1rem;
            font-family: inherit;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
        }

        input[type="email"]:focus, 
        input[type="password"]:focus {
            outline: none;
            border-color: #8B4513;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        .login-button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            font-family: inherit;
            margin-top: 1rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            border: 2px solid #2c1810;
        }

        .login-button:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            box-shadow: 0 6px 12px rgba(0,0,0,0.3);
        }

        .login-button:active {
            transform: translateY(1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* Messages */
        .message {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 0.95rem;
            font-weight: 500;
            border: 1px solid;
        }

        .message.error {
            background: #f8d7da;
            color: #dc3545;
            border-color: #f5c6cb;
        }

        .message.success {
            background: #d4edda;
            color: #28a745;
            border-color: #c3e6cb;
        }

        .login-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e0e0e0;
            font-size: 0.9rem;
        }

        .login-footer a {
            color: #8B4513;
            text-decoration: none;
            font-weight: 600;
        }

        .login-footer a:hover {
            color: #654321;
            text-decoration: underline;
        }

        .divider {
            margin: 0 10px;
            color: #999;
        }

        /* Effet de profondeur pour le conteneur */
        .login-container::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #8B4513, #654321, #2c1810);
            border-radius: 18px;
            z-index: -1;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .login-container {
                padding: 2rem 1.5rem;
                max-width: 100%;
            }

            .login-header h2 {
                font-size: 1.5rem;
            }

            .logo-icon {
                width: 70px;
                height: 70px;
                font-size: 28px;
            }

            input[type="email"], 
            input[type="password"] {
                padding: 10px 12px 10px 40px;
                font-size: 16px; /* Évite le zoom sur iOS */
            }

            .login-button {
                padding: 12px;
                font-size: 16px;
            }
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 1.5rem 1rem;
            }

            .login-header h2 {
                font-size: 1.3rem;
            }

            .logo-icon {
                width: 60px;
                height: 60px;
                font-size: 24px;
            }

            .login-footer {
                font-size: 0.85rem;
            }
        }

        /* Amélioration de l'accessibilité */
        .login-button:focus {
            outline: 3px solid rgba(139, 69, 19, 0.3);
            outline-offset: 2px;
        }

        input[type="email"]:focus, 
        input[type="password"]:focus {
            outline: none;
        }

        /* Style pour les navigateurs qui supportent backdrop-filter */
        @supports (backdrop-filter: blur(10px)) {
            .login-container {
                backdrop-filter: blur(10px);
                background: rgba(255, 255, 255, 0.95);
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="logo-icon">📚</div>
            <h2>Connexion</h2>
            <p>Accédez à votre espace bibliothèque</p>
        </div>

        <c:if test="${not empty error}">
            <div class="message error">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="message success">
                ${success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="form-group">
                <label for="email">Adresse email</label>
                <div class="input-wrapper email">
                    <input type="email" id="email" name="email" required value="${param.email}"/>
                </div>
            </div>

            <div class="form-group">
                <label for="motDePasse">Mot de passe</label>
                <div class="input-wrapper password">
                    <input type="password" id="motDePasse" name="motDePasse" required/>
                </div>
            </div>

            <button type="submit" class="login-button">Se connecter</button>
        </form>

        <div class="login-footer">
            <a href="${pageContext.request.contextPath}/auth/forgot-password">Mot de passe oublié ?</a>
            <span class="divider">|</span>
            <a href="${pageContext.request.contextPath}/auth/register">Créer un compte</a>
        </div>
    </div>
</body>
</html>