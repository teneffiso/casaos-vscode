FROM node:lts

WORKDIR /vscode

RUN apt-get update \
    && apt-get install -y locales wget gpg apt-transport-https \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' \
    && rm -f packages.microsoft.gpg

RUN apt-get update \
    && apt-get install -y code \
    && rm -rf /var/lib/apt/lists/*

RUN chown daemon:daemon /vscode

USER daemon

CMD code serve-web --connection-token=$CONNECTION_TOKEN