@echo off
setlocal

:: === Configuration ===
set "PROJECT_DIR=E:\S4\INF209-Web_Dyn(Mr_Naina)\Tp_Spring\VraiExamenBiblio\Bibliotheque"
::del /f /q "C:\xampp\tomcat\webapps\SpringInit_film.war"
set WAR_NAME=Projet_Bibliotheque.war
set TOMCAT_WEBAPPS_DIR=C:\Tomcat\apache-tomcat-10.1.28\webapps

:: === Aller dans le dossier du projet ===
cd /d "%PROJECT_DIR%"

echo.
echo [1/3] Nettoyage du projet...
call mvn clean compile

echo.
echo [2/3] Construction du fichier WAR...
call mvn package

:: Vérifier si le .war a été généré
if not exist "target\%WAR_NAME%" (
    echo ERREUR: Le fichier %WAR_NAME% n'a pas été généré.
    exit /b 1
)

echo.
echo [3/3] Déploiement vers Tomcat...
copy /Y "target\%WAR_NAME%" "%TOMCAT_WEBAPPS_DIR%\"

echo.
echo Deploiement termine. Vérifiez Tomcat à l'adresse http://localhost:8080/Projet_Bibliotheque/
pause
endlocal
