# syntax=docker/dockerfile:1.0.0-experimental
ARG IMAGE=ubuntu
ARG IMAGE_VERSION=lunar

FROM $IMAGE:$IMAGE_VERSION

ARG UID=1000
ARG GID=1000
ARG USERNAME=
ARG DOTFILES_URL=

ENV RUNNING_IN_DOCKER=true
ENV DOTFILES_TEST_CONTAINER=true
ENV DOTFILES_URL=${DOTFILES_URL}
ENV TERM=xterm-256color

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        rsync \
        ca-certificates \
        curl \
        openssh-client \
        sudo \
        zsh
    
COPY install /home/${USERNAME}/install

RUN \
    set -ex; \
    cat /etc/passwd; \
    chsh -s '/usr/bin/zsh' root; \
    userdel `id -nu $UID` || true; \
    groupdel `id -ng $GID` || true; \
    addgroup --gid $GID "${USERNAME}"; \
    adduser --home "/home/${USERNAME}" --shell '/usr/bin/zsh' --uid $UID --gid $GID --no-create-home --gecos '' --disabled-password $USERNAME; \
    usermod -aG sudo "${USERNAME}"; \
    passwd -d $USERNAME; \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USERNAME}"; \
    chown -R "${UID}:${GID}" "/home/${USERNAME}"; \
    chmod -R a+rwX,o-w "/home/${USERNAME}"; \
    chmod 700 "/home/${USERNAME}/install"

USER "${USERNAME}"
WORKDIR "/home/${USERNAME}"

RUN \
    set -ex; \
    mkdir -m 700 "/home/${USERNAME}/.ssh"; \
    ssh-keyscan github.com > "/home/${USERNAME}/.ssh/known_hosts"; \
    chmod 600 "/home/${USERNAME}/.ssh/known_hosts"

ENTRYPOINT [ "/usr/bin/zsh" ]

CMD [ "install" ]
