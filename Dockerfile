FROM alpine:latest

RUN apk --no-cache add autossh && \
    adduser --disabled-password --uid 8361 autossh && \
    chown root:root /home/autossh && \
    mkdir /home/autossh/.ssh && \
    chown autossh:autossh /home/autossh/.ssh && \
    chmod 700 /home/autossh/.ssh

WORKDIR /home/autossh

ADD ./start.sh ./

USER autossh

CMD ./start.sh
