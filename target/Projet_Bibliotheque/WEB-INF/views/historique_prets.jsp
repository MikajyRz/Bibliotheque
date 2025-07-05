<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Historique des Prêts</title>
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
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            border: 2px solid #8B4513;
        }

        h2 {
            color: #2c1810;
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 2rem;
            padding: 10px 20px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid #2c1810;
        }

        .back-link:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        .table-container {
            overflow-x: auto;
            margin-top: 1rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            border: 1px solid #8B4513;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            min-width: 800px;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #8B4513;
        }

        th {
            background: linear-gradient(135deg, #2c1810 0%, #000000 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

        td {
            font-size: 0.9rem;
            color: #2c1810;
        }

        .status-returned {
            color: #8B4513;
            font-weight: 600;
            background: #f8f5f0;
            padding: 4px 8px;
            border-radius: 4px;
        }

        .status-not-returned {
            color: #ffffff;
            font-weight: 600;
            background: #2c1810;
            padding: 4px 8px;
            border-radius: 4px;
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
                margin-bottom: 1rem;
            }
            
            .back-link {
                padding: 8px 16px;
                font-size: 0.9rem;
            }
            
            th, td {
                padding: 8px 12px;
                font-size: 0.85rem;
            }
            
            th {
                font-size: 0.8rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            .back-link {
                padding: 6px 12px;
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 6px 8px;
                font-size: 0.8rem;
            }
            
            table {
                min-width: 600px;
            }
        }

        /* Amélioration pour les très petits écrans */
        @media (max-width: 360px) {
            .table-container {
                margin: 0 -1rem;
            }
            
            table {
                min-width: 500px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Historique des Prêts</h2>
    <a href="${pageContext.request.contextPath}/bibliothecaires/accueil" class="back-link">← Retour à l'accueil</a>
    
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID Prêt</th>
                    <th>Adhérent</th>
                    <th>Titre du Livre</th>
                    <th>Type de Prêt</th>
                    <th>Date de Prêt</th>
                    <th>Date de Retour Prévue</th>
                    <th>Date de Retour Réelle</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${prets}" var="pret">
                    <tr>
                        <td><c:out value="${pret.id_pret}"/></td>
                        <td><c:out value="${pret.adherent.nom}"/></td>
                        <td><c:out value="${pret.exemplaire.livre.titre}"/></td>
                        <td><c:out value="${pret.typePret.libelle}"/></td>
                        <td><fmt:formatDate value="${pret.datePret}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${pret.dateRetourPrevue}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${pret.dateRetourReelle != null}">
                                    <span class="status-returned">
                                        <fmt:formatDate value="${pret.dateRetourReelle}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-not-returned">Non retourné</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>