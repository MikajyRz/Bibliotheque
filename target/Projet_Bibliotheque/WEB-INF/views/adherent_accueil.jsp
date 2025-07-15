<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Adhérent - Bibliothèque</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .container {
            background-color: #ffffff;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.4);
            border: 3px solid #8B4513;
            position: relative;
            z-index: 1;
        }

        .welcome-header {
            text-align: center;
            color: #2c1810;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #f5f2ed 0%, #e8e0d6 100%);
            border-radius: 15px;
            border: 2px solid #8B4513;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .section-title {
            color: #2c1810;
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            text-align: center;
            border-bottom: 3px solid #8B4513;
            padding-bottom: 0.5rem;
        }

        .message {
            text-align: center;
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 10px;
            font-weight: 500;
        }

        .message.error {
            color: #8b2635;
            background: linear-gradient(135deg, #f8e6e8 0%, #f0d6d9 100%);
            border: 2px solid #d1394a;
        }

        .message.success {
            color: #2d5a2d;
            background: linear-gradient(135deg, #e8f5e8 0%, #d6edd6 100%);
            border: 2px solid #4a7c4a;
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
            margin-bottom: 3rem;
        }

        .book-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8f6f3 100%);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(44, 24, 16, 0.2);
            border: 2px solid #8B4513;
            overflow: hidden;
            padding: 1.5rem;
            position: relative;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(44, 24, 16, 0.3);
        }

        .book-card.suggested {
            border-color: #2d5a2d;
            box-shadow: 0 10px 25px rgba(45, 90, 45, 0.2);
            background: linear-gradient(135deg, #f8fff8 0%, #f0f8f0 100%);
        }

        .book-card.suggested::before {
            content: "Suggéré";
            position: absolute;
            top: 0;
            right: 0;
            background: linear-gradient(135deg, #2d5a2d 0%, #1e3d1e 100%);
            color: white;
            padding: 8px 18px;
            border-radius: 0 0 0 15px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .book-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c1810;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .book-info {
            margin-bottom: 1rem;
        }

        .book-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e8e0d6;
        }

        .book-info-label {
            font-weight: 600;
            color: #8B4513;
            font-size: 0.9rem;
        }

        .book-info-value {
            color: #654321;
            font-size: 0.9rem;
            text-align: right;
            max-width: 60%;
            word-wrap: break-word;
        }

        .book-actions {
            display: flex;
            gap: 10px;
            margin-top: 1rem;
        }

        .btn {
            padding: 12px 18px;
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            flex: 1;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
            border: 1px solid #2c1810;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            box-shadow: 0 6px 18px rgba(0,0,0,0.3);
            transform: translateY(-2px);
            border-color: #8B4513;
        }

        .btn-info {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            color: white;
            border: 1px solid #8B4513;
        }

        .btn-info:hover {
            background: linear-gradient(135deg, #2c1810 0%, #1a0f08 100%);
            transform: translateY(-2px);
            border-color: #654321;
        }

        .btn-success {
            background: linear-gradient(135deg, #2d5a2d 0%, #1e3d1e 100%);
            color: white;
            border: 1px solid #4a7c4a;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1e3d1e 0%, #0f2e0f 100%);
            transform: translateY(-2px);
            border-color: #2d5a2d;
        }

        .btn-warning {
            background: linear-gradient(135deg, #d4a574 0%, #b8925e 100%);
            color: #2c1810;
            border: 1px solid #9c7a4d;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #b8925e 0%, #9c7a4d 100%);
            transform: translateY(-2px);
            color: white;
        }

        .no-books {
            text-align: center;
            color: #8B4513;
            font-style: italic;
            padding: 2rem;
            background: linear-gradient(135deg, #f8f6f3 0%, #f0ebe4 100%);
            border-radius: 12px;
            border: 2px solid #e8e0d6;
        }

        .unavailable {
            color: #8b2635;
            font-style: italic;
            text-align: center;
            padding: 10px;
            background: linear-gradient(135deg, #f8e6e8 0%, #f0d6d9 100%);
            border-radius: 8px;
            border: 2px solid #d1394a;
        }

        .available {
            color: #2d5a2d;
            font-weight: 600;
            text-align: center;
            padding: 10px;
            background: linear-gradient(135deg, #e8f5e8 0%, #d6edd6 100%);
            border-radius: 8px;
            border: 2px solid #4a7c4a;
        }

        .logout-section {
            text-align: center;
            margin-top: 3rem;
            padding: 2rem;
            background: linear-gradient(135deg, #f5f2ed 0%, #e8e0d6 100%);
            border-radius: 15px;
            border: 2px solid #8B4513;
        }

        .logout-link {
            color: #8B4513;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            padding: 12px 24px;
            border: 2px solid #8B4513;
            border-radius: 10px;
            background: white;
            transition: all 0.3s ease;
        }

        .logout-link:hover {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        /* Modal styles pour les détails */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(44, 24, 16, 0.7);
        }

        .modal-content {
            background: linear-gradient(135deg, #ffffff 0%, #f8f6f3 100%);
            margin: 5% auto;
            padding: 2rem;
            border: 3px solid #8B4513;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #8B4513;
        }

        .modal-title {
            color: #2c1810;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .close {
            color: #8B4513;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            background: none;
            transition: color 0.3s ease;
        }

        .close:hover {
            color: #654321;
        }

        .detail-item {
            margin-bottom: 1rem;
            padding: 1rem;
            background: linear-gradient(135deg, #f5f2ed 0%, #e8e0d6 100%);
            border-radius: 10px;
            border-left: 4px solid #8B4513;
        }

        .detail-label {
            font-weight: 600;
            color: #2c1810;
            margin-bottom: 0.3rem;
        }

        .detail-value {
            color: #654321;
        }

        .exemplaires-section {
            margin-top: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #f8f6f3 0%, #f0ebe4 100%);
            border-radius: 15px;
            border: 2px solid #8B4513;
        }

        .exemplaires-title {
            color: #2c1810;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1rem;
            text-align: center;
        }

        .exemplaire-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            margin-bottom: 0.5rem;
            background: white;
            border-radius: 10px;
            border: 1px solid #e8e0d6;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .exemplaire-id {
            font-weight: 600;
            color: #2c1810;
        }

        .status-disponible {
            color: #2d5a2d;
            font-weight: 600;
        }

        .status-emprunte {
            color: #8b2635;
            font-weight: 600;
        }

        .status-reserve {
            color: #d4a574;
            font-weight: 600;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .container {
                padding: 1.5rem;
            }

            .welcome-header {
                font-size: 1.5rem;
                padding: 1rem;
            }

            .section-title {
                font-size: 1.5rem;
            }

            .books-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .book-card {
                padding: 1rem;
            }

            .book-title {
                font-size: 1.1rem;
            }

            .book-actions {
                flex-direction: column;
            }

            .modal-content {
                width: 95%;
                margin: 10% auto;
                padding: 1.5rem;
            }

            .modal-title {
                font-size: 1.3rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem;
            }

            .welcome-header {
                font-size: 1.3rem;
                padding: 0.8rem;
            }

            .section-title {
                font-size: 1.3rem;
            }

            .book-card {
                padding: 0.8rem;
            }

            .book-title {
                font-size: 1rem;
            }

            .book-info-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .book-info-value {
                max-width: 100%;
                text-align: left;
                margin-top: 0.2rem;
            }

            .btn {
                padding: 8px 12px;
                font-size: 0.8rem;
            }

            .modal-content {
                padding: 1rem;
            }

            .exemplaire-item {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="welcome-header">
        Bienvenue, <c:out value="${userName}"/>
    </div>

    <c:if test="${not empty error}">
        <div class="message error"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="message success"><c:out value="${success}"/></div>
    </c:if>

    <!-- Section des livres suggérés -->
    <h2 class="section-title">Livres suggérés pour vous</h2>
    <c:choose>
        <c:when test="${empty livresSuggeres}">
            <div class="no-books">Aucune suggestion disponible pour le moment.</div>
        </c:when>
        <c:otherwise>
            <div class="books-grid">
                <c:forEach var="livre" items="${livresSuggeres}">
                    <div class="book-card suggested">
                        <div class="book-title"><c:out value="${livre.titre}"/></div>
                        <div class="book-info">
                            <div class="book-info-item">
                                <span class="book-info-label">Type:</span>
                                <span class="book-info-value"><c:out value="${livre.typeLivre.libelle}"/></span>
                            </div>
                            <div class="book-info-item">
                                <span class="book-info-label">Édition:</span>
                                <span class="book-info-value"><c:out value="${livre.edition}"/></span>
                            </div>
                            <div class="book-info-item">
                                <span class="book-info-label">ISBN:</span>
                                <span class="book-info-value"><c:out value="${livre.isbn}"/></span>
                            </div>
                            <div class="book-info-item">
                                <span class="book-info-label">Auteur:</span>
                                <span class="book-info-value"><c:out value="${livre.auteur.nom}"/></span>
                            </div>
                        </div>
                        <div class="book-actions">
                            <button class="btn btn-info" onclick="openModal('modal-${livre.id_livre}')">Détails</button>
                        </div>
                        
                        <!-- Affichage du statut des exemplaires -->
                        <c:set var="hasAvailable" value="false"/>
                        <c:forEach var="exemp" items="${exemplaires}">
                            <c:if test="${exemp.livre.id_livre == livre.id_livre && statutsExemplaires[exemp.id_exemplaire] == 'Disponible'}">
                                <c:set var="hasAvailable" value="true"/>
                            </c:if>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${hasAvailable}">
                                <div class="available">Exemplaire disponible</div>
                            </c:when>
                            <c:otherwise>
                                <div class="unavailable">Aucun exemplaire disponible</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Section de tous les livres -->
    <h2 class="section-title">Tous les livres</h2>
    <div class="books-grid">
        <c:forEach var="livre" items="${livres}">
            <div class="book-card">
                <div class="book-title"><c:out value="${livre.titre}"/></div>
                <div class="book-info">
                    <div class="book-info-item">
                        <span class="book-info-label">Type:</span>
                        <span class="book-info-value"><c:out value="${livre.typeLivre.libelle}"/></span>
                    </div>
                    <div class="book-info-item">
                        <span class="book-info-label">Édition:</span>
                        <span class="book-info-value"><c:out value="${livre.edition}"/></span>
                    </div>
                    <div class="book-info-item">
                        <span class="book-info-label">ISBN:</span>
                        <span class="book-info-value"><c:out value="${livre.isbn}"/></span>
                    </div>
                    <div class="book-info-item">
                        <span class="book-info-label">Auteur:</span>
                        <span class="book-info-value"><c:out value="${livre.auteur.nom}"/></span>
                    </div>
                </div>
                <div class="book-actions">
                    <button class="btn btn-info" onclick="openModal('modal-${livre.id_livre}')">Détails</button>
                </div>
                
                <!-- Affichage du statut des exemplaires -->
                <c:set var="hasAvailable" value="false"/>
                <c:forEach var="exemp" items="${exemplaires}">
                    <c:if test="${exemp.livre.id_livre == livre.id_livre && statutsExemplaires[exemp.id_exemplaire] == 'Disponible'}">
                        <c:set var="hasAvailable" value="true"/>
                    </c:if>
                </c:forEach>
                <c:choose>
                    <c:when test="${hasAvailable}">
                        <div class="available">Exemplaire disponible</div>
                    </c:when>
                    <c:otherwise>
                        <div class="unavailable">Aucun exemplaire disponible</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>
    </div>

    <!-- Modals pour les détails des livres -->
    <c:forEach var="livre" items="${livres}">
        <div id="modal-${livre.id_livre}" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title"><c:out value="${livre.titre}"/></h3>
                    <button class="close" onclick="closeModal('modal-${livre.id_livre}')">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="detail-item">
                        <div class="detail-label">ISBN:</div>
                        <div class="detail-value"><c:out value="${livre.isbn}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Type de livre:</div>
                        <div class="detail-value"><c:out value="${livre.typeLivre.libelle}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Édition:</div>
                        <div class="detail-value"><c:out value="${livre.edition}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Auteur:</div>
                        <div class="detail-value"><c:out value="${livre.auteur.nom}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Âge minimum:</div>
                        <div class="detail-value"><c:out value="${livre.ageMinimum}"/> ans</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Année de publication:</div>
                        <div class="detail-value"><c:out value="${livre.anneePublication}"/></div>
                    </div>
                    
                    <div class="exemplaires-section">
                        <h4 class="exemplaires-title">Exemplaires disponibles</h4>
                        <c:set var="hasExemplaires" value="false"/>
                        <c:forEach var="exemp" items="${exemplaires}">
                            <c:if test="${exemp.livre.id_livre == livre.id_livre}">
                                <div class="exemplaire-item">
                                    <span class="exemplaire-id">Exemplaire #${exemp.id_exemplaire}</span>
                                    <span class="
                                        <c:choose>
                                            <c:when test="${statutsExemplaires[exemp.id_exemplaire] == 'Disponible'}">status-disponible</c:when>
                                            <c:when test="${statutsExemplaires[exemp.id_exemplaire] == 'Emprunté'}">status-emprunte</c:when>
                                            <c:otherwise>status-reserve</c:otherwise>
                                        </c:choose>
                                    ">
                                        <c:out value="${statutsExemplaires[exemp.id_exemplaire]}"/>
                                    </span>
                                </div>
                                <c:set var="hasExemplaires" value="true"/>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!hasExemplaires}">
                            <div class="unavailable">Aucun exemplaire trouvé</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Modals pour les livres suggérés -->
    <c:forEach var="livre" items="${livresSuggeres}">
        <div id="modal-${livre.id_livre}" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title"><c:out value="${livre.titre}"/></h3>
                    <button class="close" onclick="closeModal('modal-${livre.id_livre}')">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="detail-item">
                        <div class="detail-label">ISBN:</div>
                        <div class="detail-value"><c:out value="${livre.isbn}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Type de livre:</div>
                        <div class="detail-value"><c:out value="${livre.typeLivre.libelle}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Édition:</div>
                        <div class="detail-value"><c:out value="${livre.edition}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Auteur:</div>
                        <div class="detail-value"><c:out value="${livre.auteur.nom}"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Âge minimum:</div>
                        <div class="detail-value"><c:out value="${livre.ageMinimum}"/> ans</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Année de publication:</div>
                        <div class="detail-value"><c:out value="${livre.anneePublication}"/></div>
                    </div>
                    
                    <div class="exemplaires-section">
                        <h4 class="exemplaires-title">Exemplaires disponibles</h4>
                        <c:set var="hasExemplaires" value="false"/>
                        <c:forEach var="exemp" items="${exemplaires}">
                            <c:if test="${exemp.livre.id_livre == livre.id_livre}">
                                <div class="exemplaire-item">
                                    <span class="exemplaire-id">Exemplaire #${exemp.id_exemplaire}</span>
                                    <span class="
                                        <c:choose>
                                            <c:when test="${statutsExemplaires[exemp.id_exemplaire] == 'Disponible'}">status-disponible</c:when>
                                            <c:when test="${statutsExemplaires[exemp.id_exemplaire] == 'Emprunté'}">status-emprunte</c:when>
                                            <c:otherwise>status-reserve</c:otherwise>
                                        </c:choose>
                                    ">
                                        <c:out value="${statutsExemplaires[exemp.id_exemplaire]}"/>
                                    </span>
                                </div>
                                <c:set var="hasExemplaires" value="true"/>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!hasExemplaires}">
                            <div class="unavailable">Aucun exemplaire trouvé</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <div class="logout-section">
        <a href="${pageContext.request.contextPath}/" class="logout-link">Déconnexion</a>
    </div>
</div>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Fermer le modal en cliquant en dehors
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>