# Creation d'un script qui crée deux containers qui contiendront une version propre de Wordpress
#			- Un container Apache, un container MySQL
#     - Utilisation wpcli (permet de faire une install de wordpress en ligne de commande)

# Inititalisation du répertoire Docker
mkdir Docker
cd Docker
echo "FROM httpd:latest \n\nWORKDIR /usr/local/apache2/htdocs\n\nEXPOSE 80" > ./dockerServer

docker build -f dockerserver -t apache .
docker run -d -p 4000:80 apache

# récupération de l'id de apache
apacheId=docker ps --filter "name=apache" -q

apt-get install mysql-server
docker exec -it ${apacheId} bash
docker run --name mysql -e MYSQL_ROOT_PASSWORD=0000 -d mysql:latest

mysqlId=docker ps --filter "name=mysql:latest" -q
docker run --name apache --link ${mysqlId} -p 4000:80 -d apache .
docker exec -it b64c871c1f56 bash

# Maintenant on se connecte au server MySql
mysql -uroot -p0000 - h ${apacheId}
