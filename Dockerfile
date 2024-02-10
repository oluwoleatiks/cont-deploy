FROM ubuntu
WORKDIR /var/www/html

RUN apt update && apt install apache2 -y
RUN systemctl enable apache2 && systemctl restart apache2

COPY index.html style.css /var/wwww/html/

CMD ["tail", "-f", "/dev/null"]
