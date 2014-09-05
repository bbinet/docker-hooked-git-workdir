docker-hooked-git-workdir
=========================

Specialized [docker-hooked](https://github.com/bbinet/docker-hooked) container
to keep git repositories checkouts up to date BitBucket of Github repositories
are updated.

Build
-----

To create the image `bbinet/hooked-git-workdir`, execute the following
command in the `docker-hooked-git-workdir` folder:

    docker build -t bbinet/hooked-git-workdir .

You can now push the new image to the public registry:
    
    docker push bbinet/hooked-git-workdir


Run
---

Then, when starting your `hooked-git-workdir` container, you will want to bind
port `80` from the `hooked-git-workdir` container to a host external port.

By default, hooked is configured to always trigger the `git-workdir.sh`command,
but this can by customized by providing your own hooked config in
`/config/hooked.cfg`.

The `/data` directory is a volume and the `git-workdir.sh` script will look for
repositories to checkout in the `/data/repositories` directory, and will
checkout branches in `/data/checkout.`
These paths can be customized by setting the following environment variables:

    - `GIT_REPO_PATH`
    - `GIT_WORKDIR_PATH`

For example:

    $ docker pull bbinet/hooked-git-workdir

    $ docker run --name hooked-git-workdir \
        -v /home/hooked/data:/data \
        -e GIT_REPO_PATH=/data/my/repos \
        -e GIT_WORKDIR_PATH=/data/my/workdirs \
        -p 80:80 \
        bbinet/hooked-git-workdir
