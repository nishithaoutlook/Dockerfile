FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server nginx
RUN mkdir /var/run/sshd
RUN echo 'root:Passw0rd' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# tampered file used on labs
RUN cp /usr/sbin/nginx /usr/sbin/nginx_org
COPY files/tampered_nginx /usr/sbin/nginx

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Ansible enabled image
RUN apt-get update && apt-get install -y python sudo bash ca-certificates iproute2 && apt-get clean;

# Additional Files
ADD assets/myna-script.sh /opt/
RUN chmod 755 /opt/myna-script.sh
