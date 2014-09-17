FROM bbinet/hooked

MAINTAINER Bruno Binet <bruno.binet@helioslite.com>

ADD backports.list /etc/apt/sources.list.d/backports.list
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  openssh-client && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  -t wheezy-backports git

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ADD git-workdir.sh /git-workdir.sh
RUN chmod a+x /git-workdir.sh
ENV GIT_REPO_PATH /data/repositories
ENV GIT_WORKDIR_PATH /data/workdir
ENV GIT_SSH /usr/bin/ssh
ENV BEFORE_EXEC_SCRIPT /config/before-exec.sh

ADD hooked.cfg /etc/hooked.cfg

VOLUME ["/data"]

EXPOSE 80

ENV EXEC_CMD hooked /config/hooked.cfg

CMD ["/run.sh"]
