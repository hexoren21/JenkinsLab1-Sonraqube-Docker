FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt update && apt install apache2 wget unzip -y
RUN wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip
RUN unzip 2135_mini_finance.zip
RUN cp -r 2135_mini_finance/* /var/www/html/
CMD ["apachectl", "-D", "FOREGROUND"]