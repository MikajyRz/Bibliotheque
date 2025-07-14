```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Accueil Bibliothécaire</title>
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
        }

        .container {
            background-color: #ffffff;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.4);
            border: 3px solid #8B4513;
        }

        h2 {
            text-align: center;
            color: #2c1810;
            margin-bottom: 2.5rem;
            font-size: 2rem;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .navbar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 2.5rem;
            padding: 1rem;
            background: rgba(139, 69, 19, 0.1);
            border-radius: 12px;
            border: 1px solid #8B4513;
        }

        .navbar a {
            padding: 12px 20px;
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            border: 2px solid #2c1810;
            text-align: center;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .navbar a:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            box-shadow: 0 6px 12px rgba(0,0,0,0.3);
        }

        .content-section {
            background: #fafafa;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            border: 1px solid #e0e0e0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: #ffffff;
            font-weight: 600;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }

        tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        tr:hover {
            background-color: #f0e6d6;
        }

        .no-results, .message {
            text-align: center;
            color: #2c1810;
            font-style: italic;
            margin: 2rem 0;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .success-message {
            color: #28a745;
            background: #d4edda;
            border-color: #c3e6cb;
        }

        .error-message {
            color: #dc3545;
            background: #f8d7da;
            border-color: #f5c6cb;
        }

        .form-container {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2c1810;
            font-weight: 600;
        }

        .form-group select, 
        .form-group input[type="text"],
        .form-group input[type="date"],
        .form-group input[type="number"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            background: white;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #8B4513;
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .btn-primary {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #654321 0%, #2c1810 100%);
            box-shadow: 0 6px 12px rgba(0,0,0,0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1e7e34 0%, #155724 100%);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
        }

        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
        }

        .btn-info:hover {
            background: linear-gradient(135deg, #138496 0%, #0f6674 100%);
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .return-form, .action-form {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .return-form input[type="date"], 
        .action-form input[type="date"] {
            min-width: 140px;
            padding: 6px 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.875rem;
        }

        .retard { 
            color: #dc3545; 
            font-weight: 600;
        }

        .table-responsive {
            overflow-x: auto;
            margin-top: 1rem;
        }

        .search-form {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .search-title {
            color: #2c1810;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .welcome-message {
            text-align: center;
            color: #2c1810;
            font-size: 1.8rem;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: rgba(139, 69, 19, 0.1);
            border-radius: 12px;
            border: 2px solid #8B4513;
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

            .navbar {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }

            .return-form, .action-form {
                flex-direction: column;
                align-items: stretch;
            }

            .return-form input[type="date"], 
            .action-form input[type="date"] {
                min-width: auto;
            }

            th, td {
                padding: 8px;
                font-size: 0.875rem;
            }

            .table-responsive {
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

            .navbar a {
                padding: 10px 15px;
                font-size: 0.9rem;
            }

            .form-container,
            .search-form {
                padding: 1.5rem;
            }

            th, td {
                padding: 6px;
                font-size: 0.8rem;
            }

            .btn {
                padding: 10px 16px;
                font-size: 0.9rem;
            }

            .btn-sm {
                padding: 5px 10px;
                font-size: 0.8rem;
            }
        }

        /* Amélioration des tableaux sur mobile */
        @media (max-width: 600px) {
            .table-responsive table {
                font-size: 0.75rem;
            }

            .table-responsive th,
            .table-responsive td {
                padding: 4px;
                word-wrap: break-word;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Bienvenue, ${userName}</h2>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/prets/nouveau/accueil?section=pret">Prêter un exemplaire</a>
        <a href="${pageContext.request.contextPath}/prets/historique/accueil?section=historique">Historique des prêts</a>
        <a href="${pageContext.request.contextPath}/prets/recherche?section=recherche">Recherche des prêts</a>
        <a href="${pageContext.request.contextPath}/reservations/nouveau/accueil?section=reservation">Réserver un exemplaire</a>
        <a href="${pageContext.request.contextPath}/reservations/demandes/accueil?section=demande_reservation">Demandes de réservation</a>
        <a href="${pageContext.request.contextPath}/penalites/appliquer">Appliquer une pénalité</a>
        <a href="${pageContext.request.contextPath}/penalites/historique">Historique des pénalités</a>
        <a href="${pageContext.request.contextPath}/prets/prolongements/demandes">Demandes de prolongement</a>
        <a href="${pageContext.request.contextPath}/auth/logout">Déconnexion</a>
    </div>

    <c:if test="${section == 'pret'}">
        <h2>Prêter un exemplaire</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
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
                <input type="date" name="datePret" id="datePret"/>
            </div>
            <div class="form-group">
                <input type="submit" value="Valider le prêt"/>
            </div>
        </form>
    </c:if>

    <c:if test="${section == 'historique'}">
        <h2>Historique des prêts</h2>
        <table>
            <tr>
                <th>ID Prêt</th>
                <th>Adhérent</th>
                <th>Exemplaire</th>
                <th>Type de prêt</th>
                <th>Date de prêt</th>
                <th>Date de retour prévue</th>
                <th>Date de retour réelle</th>
                <th>Jours de prolongation</th>
            </tr>
            <fmt:timeZone value="EAT">
                <c:forEach items="${prets}" var="pret">
                    <tr>
                        <td>${pret.id_pret}</td>
                        <td>${pret.adherent.nom}</td>
                        <td>#${pret.exemplaire.id_exemplaire} (${pret.exemplaire.livre.titre})</td>
                        <td>${pret.typePret.libelle}</td>
                        <td><fmt:formatDate value="${pret.datePret}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${pret.dateRetourPrevue}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty pret.dateRetourReelle}">
                                    <c:if test="${pret.dateRetourReelle > pret.dateRetourPrevue}">
                                        <span class="retard"><fmt:formatDate value="${pret.dateRetourReelle}" pattern="yyyy-MM-dd" /></span>
                                    </c:if>
                                    <c:if test="${pret.dateRetourReelle <= pret.dateRetourPrevue}">
                                        <fmt:formatDate value="${pret.dateRetourReelle}" pattern="yyyy-MM-dd" />
                                    </c:if>
                                </c:when>
                                <c:otherwise>Non retourné</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${pret.nbProlongements > 0}">
                                    <c:set var="datePret" value="${pret.datePret}"/>
                                    <c:set var="dureePret" value="${pret.adherent.typeAdherent.dureePret}"/>
                                    <jsp:useBean id="initialRetourPrevue" class="java.util.Date"/>
                                    <c:set target="${initialRetourPrevue}" property="time" value="${datePret.time + dureePret * 24 * 60 * 60 * 1000}"/>
                                    <c:set var="joursProlongation" value="${(pret.dateRetourPrevue.time - initialRetourPrevue.time) / (1000 * 60 * 60 * 24)}"/>
                                    <fmt:formatNumber value="${joursProlongation}" pattern="0"/>
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </fmt:timeZone>
        </table>
    </c:if>

    <c:if test="${section == 'recherche'}">
        <h2>Recherche multicritère des prêts</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/prets/recherche" method="post">
            <div class="form-group">
                <label for="adherent">Adhérent (nom ou email) :</label>
                <input type="text" name="adherent" id="adherent" value="${param.adherent}"/>
            </div>
            <div class="form-group">
                <label for="exemplaire">Exemplaire (titre ou ID) :</label>
                <input type="text" name="exemplaire" id="exemplaire" value="${param.exemplaire}"/>
            </div>
            <div class="form-group">
                <label for="idTypePret">Type de prêt :</label>
                <select name="idTypePret" id="idTypePret">
                    <option value="">Tous</option>
                    <c:forEach items="${typesPret}" var="typePret">
                        <option value="${typePret.id_type_pret}" ${param.idTypePret == typePret.id_type_pret ? 'selected' : ''}>${typePret.libelle}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="dateDebut">Date de prêt (début) :</label>
                <input type="date" name="dateDebut" id="dateDebut" value="${param.dateDebut}"/>
            </div>
            <div class="form-group">
                <label for="dateFin">Date de prêt (fin) :</label>
                <input type="date" name="dateFin" id="dateFin" value="${param.dateFin}"/>
            </div>
            <div class="form-group">
                <input type="submit" value="Rechercher"/>
            </div>
        </form>

        <c:if test="${not empty searchResults}">
            <h2>Résultats de la recherche</h2>
            <c:choose>
                <c:when test="${empty searchResults}">
                    <p class="no-results">Aucun prêt trouvé pour ces critères.</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <th>ID Prêt</th>
                            <th>Adhérent</th>
                            <th>Exemplaire</th>
                            <th>Type de prêt</th>
                            <th>Date de prêt</th>
                            <th>Date de retour prévue</th>
                            <th>Date de retour réelle</th>
                            <th>Actions</th>
                        </tr>
                        <fmt:timeZone value="EAT">
                            <c:forEach items="${searchResults}" var="pret">
                                <tr>
                                    <td>${pret.id_pret}</td>
                                    <td>${pret.adherent.nom}</td>
                                    <td>#${pret.exemplaire.id_exemplaire} (${pret.exemplaire.livre.titre})</td>
                                    <td>${pret.typePret.libelle}</td>
                                    <td><fmt:formatDate value="${pret.datePret}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${pret.dateRetourPrevue}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty pret.dateRetourReelle}">
                                                <fmt:formatDate value="${pret.dateRetourReelle}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Non retourné</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${empty pret.dateRetourReelle}">
                                            <form action="${pageContext.request.contextPath}/prets/retour" method="post" class="return-form">
                                                <input type="hidden" name="idAdherent" value="${pret.adherent.id_adherent}"/>
                                                <input type="hidden" name="idExemplaire" value="${pret.exemplaire.id_exemplaire}"/>
                                                <input type="hidden" name="adherent" value="${param.adherent}"/>
                                                <input type="hidden" name="exemplaire" value="${param.exemplaire}"/>
                                                <input type="hidden" name="idTypePret" value="${param.idTypePret}"/>
                                                <input type="hidden" name="dateDebut" value="${param.dateDebut}"/>
                                                <input type="hidden" name="dateFin" value="${param.dateFin}"/>
                                                <input type="date" name="dateRetour" required/>
                                                <input type="submit" value="Retourner"/>
                                            </form>
                                            <c:if test="${pret.nbProlongements < 1 && pret.typePret.id_type_pret != 2}">
                                                <form action="${pageContext.request.contextPath}/prets/demander-prolongement" method="post" class="return-form">
                                                    <input type="hidden" name="idPret" value="${pret.id_pret}"/>
                                                    <input type="hidden" name="adherent" value="${param.adherent}"/>
                                                    <input type="hidden" name="exemplaire" value="${param.exemplaire}"/>
                                                    <input type="hidden" name="idTypePret" value="${param.idTypePret}"/>
                                                    <input type="hidden" name="dateDebut" value="${param.dateDebut}"/>
                                                    <input type="hidden" name="dateFin" value="${param.dateFin}"/>
                                                    <input type="date" name="dateProlongement" data-max-prolongement="${pret.adherent.typeAdherent.nbJourMaxProlongement}" data-date-retour-prevue="<fmt:formatDate value="${pret.dateRetourPrevue}" pattern="yyyy-MM-dd"/>" required/>
                                                    <input type="submit" value="Demander prolonger"/>
                                                </form>
                                            </c:if>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </fmt:timeZone>
                    </table>
                </c:otherwise>
            </c:choose>
        </c:if>
    </c:if>

    <c:if test="${section == 'reservation'}">
        <h2>Réserver un exemplaire</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/reservations/nouveau" method="post">
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
                <label for="dateReservation">Date de réservation :</label>
                <input type="date" name="dateReservation" id="dateReservation" required/>
            </div>
            <div class="form-group">
                <input type="submit" value="Valider la réservation"/>
            </div>
        </form>
    </c:if>

    <c:if test="${section == 'demande_reservation'}">
        <h2>Demandes de réservation</h2>
        <c:if test="${not empty successMessage}">
            <p class="message success-message">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error-message">${errorMessage}</p>
        </c:if>
        <c:choose>
            <c:when test="${empty reservations}">
                <p class="no-results">Aucune demande de réservation en attente.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>ID Réservation</th>
                        <th>Adhérent</th>
                        <th>Exemplaire</th>
                        <th>Date de réservation</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                    <fmt:timeZone value="EAT">
                        <c:forEach items="${reservations}" var="reservation">
                            <tr>
                                <td>${reservation.id_reservation}</td>
                                <td>${reservation.adherent.nom}</td>
                                <td>#${reservation.exemplaire.id_exemplaire} (${reservation.exemplaire.livre.titre})</td>
                                <td><fmt:formatDate value="${reservation.dateReservation}" pattern="dd/MM/yyyy"/></td>
                                <td>${reservation.statutReservation.libelle}</td>
                                <td>
                                    <c:if test="${reservation.statutReservation.libelle == 'en attente'}">
                                        <form action="${pageContext.request.contextPath}/reservations/accepter" method="post" class="action-form">
                                            <input type="hidden" name="idReservation" value="${reservation.id_reservation}"/>
                                            <input type="hidden" name="idAdherent" value="${reservation.adherent.id_adherent}"/>
                                            <input type="hidden" name="idExemplaire" value="${reservation.exemplaire.id_exemplaire}"/>
                                            <input type="hidden" name="dateReservation" value="<fmt:formatDate value='${reservation.dateReservation}' pattern='yyyy-MM-dd'/>"/>
                                            <input type="submit" value="Accepter"/>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/reservations/refuser" method="post" class="action-form">
                                            <input type="hidden" name="idReservation" value="${reservation.id_reservation}"/>
                                            <input type="submit" value="Refuser"/>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </fmt:timeZone>
                </table>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${section == 'penalite'}">
        <h2>Appliquer une pénalité</h2>
        <c:if test="${not empty successMessage}">
            <div class="success-message">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/penalites/appliquer" method="post">
            <div class="form-group">
                <label for="idPret">Prêt :</label>
                <select name="idPret" id="idPret" required>
                    <option value="">Sélectionner un prêt</option>
                    <c:forEach items="${prets}" var="pret">
                        <option value="${pret.id_pret}">Prêt #${pret.id_pret} - Adhérent: ${pret.adherent.nom}, Exemplaire: #${pret.exemplaire.id_exemplaire}</option>
                    </c:forEach>
                </select>
            </div>
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
                <label for="dureePenalite">Durée de la pénalité (jours) :</label>
                <input type="number" name="dureePenalite" id="dureePenalite" required>
            </div>
            <div class="form-group">
                <label for="dateApplication">Date d'application :</label>
                <input type="date" name="dateApplication" id="dateApplication" required>
            </div>
            <button type="submit">Appliquer la pénalité</button>
        </form>
    </c:if>

    <c:if test="${section == 'historique_penalites'}">
        <h2>Historique des pénalités</h2>
        <c:choose>
            <c:when test="${empty penalites}">
                <p>Aucune pénalité trouvée.</p>
            </c:when>
            <c:otherwise>
                <table border="1">
                    <tr>
                        <th>ID Pénalité</th>
                        <th>Prêt</th>
                        <th>Adhérent</th>
                        <th>Durée (jours)</th>
                        <th>Date d'application</th>
                        <th>Date de retour réelle</th>
                        <th>Date de fin de pénalité</th>
                    </tr>
                    <c:forEach items="${penalites}" var="penalite">
                        <tr>
                            <td>${penalite.id_penalite}</td>
                            <td>Prêt #${penalite.pret.id_pret}</td>
                            <td>${penalite.pret.adherent.nom}</td>
                            <td>${penalite.dureePenalite}</td>
                            <td>
                                <fmt:formatDate value="${penalite.dateApplication}" pattern="yyyy-MM-dd" />
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty penalite.pret.dateRetourReelle}">
                                        <fmt:formatDate value="${penalite.pret.dateRetourReelle}" pattern="yyyy-MM-dd" />
                                    </c:when>
                                    <c:otherwise>Non retourné</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <jsp:useBean id="dateFinPenalite" class="java.util.Date" />
                                <c:set target="${dateFinPenalite}" property="time" 
                                       value="${penalite.dateApplication.time + (penalite.dureePenalite * 24 * 60 * 60 * 1000)}" />
                                <fmt:formatDate value="${dateFinPenalite}" pattern="yyyy-MM-dd" />
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:if test="${section == 'demandes_prolongements'}">
        <h2>Demandes de prolongement</h2>
        <c:if test="${not empty successMessage}">
            <p style="color: green;">${successMessage}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p style="color: red;">${errorMessage}</p>
        </c:if>
        <c:choose>
            <c:when test="${empty prolongements}">
                <p>Aucune demande de prolongement en attente.</p>
            </c:when>
            <c:otherwise>
                <table border="1">
                    <tr>
                        <th>ID Demande</th>
                        <th>Prêt</th>
                        <th>Adhérent</th>
                        <th>Exemplaire</th>
                        <th>Date de prêt</th>
                        <th>Date de retour prévue actuelle</th>
                        <th>Date de prolongation proposée</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                    <c:forEach items="${prolongements}" var="prolongement">
                        <tr>
                            <td>${prolongement.id_prolongement}</td>
                            <td>Prêt #${prolongement.pret.id_pret}</td>
                            <td>${prolongement.pret.adherent.nom}</td>
                            <td>#${prolongement.pret.exemplaire.id_exemplaire} (${prolongement.pret.exemplaire.livre.titre})</td>
                            <td><fmt:formatDate value="${prolongement.pret.datePret}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${prolongement.pret.dateRetourPrevue}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${prolongement.dateProlongementProposee}" pattern="yyyy-MM-dd" /></td>
                            <td>${prolongement.statut}</td>
                            <td>
                                <c:if test="${prolongement.statut == 'en attente'}">
                                    <form action="${pageContext.request.contextPath}/prets/prolongements/accepter" method="post" style="display:inline;">
                                        <input type="hidden" name="idProlongement" value="${prolongement.id_prolongement}" />
                                        <input type="hidden" name="idBibliothecaire" value="${sessionScope.userId}" />
                                        <input type="submit" value="Accepter" />
                                    </form>
                                    <form action="${pageContext.request.contextPath}/prets/prolongements/refuser" method="post" style="display:inline;">
                                        <input type="hidden" name="idProlongement" value="${prolongement.id_prolongement}" />
                                        <input type="submit" value="Refuser" />
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </c:if>

    
</div>
<script>
    // Validation pour dateProlongement
    document.querySelectorAll('.return-form input[name="dateProlongement"]').forEach(input => {
        input.addEventListener('change', () => {
            const dateProlongement = new Date(input.value);
            const dateRetourPrevue = new Date(input.dataset.dateRetourPrevue);
            const nbJourMaxProlongement = parseInt(input.dataset.maxProlongement);
            const maxDate = new Date(dateRetourPrevue);
            maxDate.setDate(maxDate.getDate() + nbJourMaxProlongement);
            if (dateProlongement > maxDate) {
                alert(`La date de prolongation ne peut pas dépasser ${maxDate.toLocaleDateString('fr-FR')}.`);
                input.value = '';
            } else if (dateProlongement <= dateRetourPrevue) {
                alert('La date de prolongation doit être postérieure à la date de retour prévue.');
                input.value = '';
            }
        });
    });

    // Validation pour dateReservation
    const dateReservationInput = document.querySelector('input[name="dateReservation"]');
    if (dateReservationInput) {
        dateReservationInput.addEventListener('change', () => {
            const selectedDate = new Date(dateReservationInput.value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (selectedDate < today) {
                alert('La date de réservation ne peut pas être dans le passé.');
                dateReservationInput.value = '';
            }
        });
    }
</script>
</body>
</html>