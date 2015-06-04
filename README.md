docker-hooked-git-workdir
=========================

Specialized [docker-hooked](https://github.com/bbinet/docker-hooked) container
to keep git repositories checkouts up to date when BitBucket or Github
repositories are updated.

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

By default, hooked is configured to always trigger the `git-workdir.sh` command,
but this can by customized by providing your own hooked config in
`/config/hooked.cfg`.

If you want to checkout a private git repository, you can put your `id_rsa`
ssh private key in the `/config` volume and provide a custom `git_ssh` script
like the following:

    $ cat /config/git_ssh
    #!/bin/bash
    /usr/bin/ssh -i /config/.ssh/id_rsa "$@"

Then, you will have to set the following environment variable, for git to use
you custom `/config/.ssh/id_rsa` ssh private key:

  - `GIT_SSH=/config/git_ssh`

The `/data` directory is a volume and the `git-workdir.sh` script will look for
repositories to checkout in the `/data/repositories` directory, and will
checkout branches in `/data/workdir.`
These paths can be customized by setting the following environment variables:

  - `GIT_REPO_PATH` (defaults to `/data/repositories`)
  - `GIT_WORKDIR_PATH` (defaults to `/data/workdir`)

For example:

    $ docker pull bbinet/hooked-git-workdir

    $ docker run --name hooked-git-workdir \
        -v /home/hooked/data:/data \
        -e GIT_REPO_PATH=/data/my/repos \
        -e GIT_WORKDIR_PATH=/data/my/workdirs \
        -e GIT_SSH=/config/git_ssh \
        -p 80:80 \
        bbinet/hooked-git-workdir

Add git Repos
-------------

To add a git repo:

```
$ sudo -s
# cd /home/hooked/data
# mkdir repositories
# git clone https://github.com/me/my-repo
Cloning into 'my-repo'...
remote: Counting objects: 975, done.
remote: Compressing objects: 100% (542/542), done.
remote: Total 975 (delta 413), reused 975 (delta 413), pack-reused 0
Receiving objects: 100% (975/975), 750.18 KiB, done.
Resolving deltas: 100% (413/413), done.
```

Testing Web Hook
----------------
Use curl to hit the hook server:

```
$ curl -s localhost:8080/hooks/my-repo/master | python -mjson.tool
{
    "hooks": [
        {
            "branch": null,
            "command": "/git-workdir.sh",
            "cwd": null,
            "name": "all",
            "repository": null,
            "stderr": "Note: checking out 'origin/master'.\n\nYou are in 'detached HEAD' state. You can look around, make experimental\nchanges and commit them, and you can discard any commits you make in this\nstate without impacting any branches by performing another checkout.\n\nIf you want to create a new branch to retain commits you create, you may\ndo so (now or later) by using -b with the checkout command again. Example:\n\n  git checkout -b new_branch_name\n\nHEAD is now at ca60959... Random commit message\nHEAD is now at ca60959... Random commit message\n",
            "stdout": "No local changes to save\n"
        }
    ],
    "success": true
}
```
