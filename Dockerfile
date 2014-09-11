FROM bbinet/hooked

MAINTAINER Bruno Binet <bruno.binet@helioslite.com>

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  git

ADD git-workdir.sh /git-workdir.sh
RUN chmod a+x /git-workdir.sh

ADD hooked.cfg /etc/hooked.cfg

VOLUME ["/data"]

EXPOSE 80

ENV EXEC_CMD "hooked /config/hooked.cfg"

CMD ["/run.sh"]
