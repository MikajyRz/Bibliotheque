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
            font-family: 'Georgia', serif;
            background-image: url('https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: #ffffff;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            border: 1px solid #e0e0e0;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: #d4af37;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 24px;
            color: #ffffff;
        }

        .login-header h2 {
            color: #1a1a2e;
            font-size: 24px;
            font-weight: 400;
            margin-bottom: 8px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 12px;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            z-index: 2;
        }

        .input-wrapper.email::before {
            content: '📧';
            font-size: 14px;
        }

        .input-wrapper.password::before {
            content: '🔒';
            font-size: 14px;
        }

        input[type="email"], 
        input[type="password"] {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background: #fafafa;
            color: #333;
            font-size: 14px;
            font-family: inherit;
        }

        input[type="email"]:focus, 
        input[type="password"]:focus {
            outline: none;
            border-color: #d4af37;
            background: #ffffff;
        }

        .login-button {
            width: 100%;
            padding: 14px;
            background: #d4af37;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            font-family: inherit;
            margin-top: 10px;
        }

        .login-button:active {
            background: #c19b26;
        }

        /* Messages */
        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }

        .message.error {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }

        .message.success {
            background: #e8f5e8;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }

        .login-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            font-size: 14px;
        }

        .login-footer a {
            color: #d4af37;
            text-decoration: none;
            font-weight: 500;
        }

        .login-footer a:visited {
            color: #d4af37;
        }

        .divider {
            margin: 0 8px;
            color: #999;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .login-container {
                padding: 30px 25px;
                max-width: 100%;
            }

            .login-header h2 {
                font-size: 20px;
            }

            .logo-icon {
                width: 50px;
                height: 50px;
                font-size: 20px;
            }

            input[type="email"], 
            input[type="password"] {
                padding: 10px 10px 10px 35px;
                font-size: 16px; /* Évite le zoom sur iOS */
            }

            .login-button {
                padding: 12px;
                font-size: 16px;
            }
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 25px 20px;
            }

            .login-header h2 {
                font-size: 18px;
            }

            .login-footer {
                font-size: 13px;
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
                    <input type="email" 
                           id="email" 
                           name="email" 
                           required 
                           value="${param.email}"/>
                </div>
            </div>

            <div class="form-group">
                <label for="motDePasse">Mot de passe</label>
                <div class="input-wrapper password">
                    <input type="password" 
                           id="motDePasse" 
                           name="motDePasse" 
                           required/>
                </div>
            </div>

            <button type="submit" class="login-button">
                Se connecter
            </button>
        </form>

        <div class="login-footer">
            <a href="${pageContext.request.contextPath}/auth/forgot-password">Mot de passe oublié ?</a>
            <span class="divider">|</span>
            <a href="${pageContext.request.contextPath}/auth/register">Créer un compte</a>
        </div>
    </div>
</body>
</html>