#!/bin/bash

set -e

repos="${GIT_REPO_PATH:-/data/repositories}"
workdir="${GIT_WORKDIR_PATH:-/data/workdir}"

if [ "$#" -ne 2 ]
then
  echo "Usage: $0 <repository name> <branch>"
  exit 1
fi

repo="$1"
branch="$2"
repo_path="${repos}/${repo}"
branch_path="${workdir}/${repo}/${branch}"

if [ ! -d "${repo_path}/.git" ]
then
  echo "No such git repository: ${repo_path}"
  exit 1
fi

(cd "${repo_path}";
  git fetch origin +refs/heads/${branch}:refs/remotes/origin/${branch}
)

if [ ! -d "${branch_path}" ]
then
  mkdir -p "${workdir}/${repo}"
  sh /usr/share/doc/git/contrib/workdir/git-new-workdir \
    "${repo_path}" "${branch_path}" "${branch}"
fi

(cd ${branch_path};
  git stash
  git rebase origin/$branch
)
