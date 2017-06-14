# Creation d'un script qui crée deux containers qui contiendront une version propre de Wordpress
#			- Un container Apache, un container MySQL
#     - Utilisation wpcli (permet de faire une install de wordpress en ligne de commande)

# Inititalisation du répertoire Docker
mkdir Docker
cd Docker
echo "FROM httpd:latest \n\nWORKDIR /usr/local/apache2/htdocs\n\nEXPOSE 80\n\nRUN apt-get update && apt-get install -y php5 && apt-get install -y php5-mysql && apt-get install -y curl && rm index.html \n\n CMD [“apachectl”, “-DFOREGROUND”] " > ./dockerServer

docker build -f dockerserver -t apache .
docker run -d -p 4000:80 apache

# récupération de l'id de apache
apacheId=docker ps --filter "name=apache" -q

docker exec -it ${apacheId} bash
docker run --name mysql -e MYSQL_ROOT_PASSWORD=0000 -d mysql:latest

# Une fois sur le serveur APACHE
mysqlId=docker ps --filter "name=mysql:latest" -q
docker run --name apache --link ${mysqlId} -p 4000:80 -d apache .
docker exec -it ${apacheId} bash

#install WP

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root
wp core config --dbname=WP --dbhost=19145ccbc52a --dbuser=root --dbpass=0000 --locale=en_EN --allow-root
wp db create --allow-root
wp core install --url=localhost:4000 --title=super --admin_user=root  --admin_password=0000 --admin_email=yo@gmail.com --skip-email --allow-root
