FROM bbinet/hooked

MAINTAINER Bruno Binet <bruno.binet@helioslite.com>

ENV DEBIAN_FRONTEND noninteractive
ENV GOSU_VERSION 1.10
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN apt-get update && \
  apt-get install -yq --no-install-recommends openssh-client git ca-certificates

ADD hooked.cfg /etc/hooked.cfg
ADD run.sh /run.sh
RUN chmod a+x /run.sh
ADD git-workdir.sh /git-workdir.sh
RUN chmod a+x /git-workdir.sh

ENV GIT_REPO_PATH /repositories
ENV GIT_WORKDIR_PATH /workdir
ENV GIT_SSH /usr/bin/ssh
ENV HOOKED_CONFIG /etc/hooked
ENV BEFORE_SU_EXEC_SCRIPT ${HOOKED_CONFIG}/before-su-exec.sh
ENV BEFORE_EXEC_SCRIPT ${HOOKED_CONFIG}/before-exec.sh

EXPOSE 8000

ENV EXEC_CMD hooked ${HOOKED_CONFIG}/hooked.cfg

CMD ["/run.sh"]
