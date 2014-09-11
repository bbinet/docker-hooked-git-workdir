#!/bin/bash

set -e

if [ "$#" -ne 2 ]
then
  echo "Usage: $0 <repository name> <branch>"
  exit 1
fi

repo="$1"
branch="$2"
repo_path="${GIT_REPO_PATH}/${repo}"
branch_path="${GIT_WORKDIR_PATH}/${repo}/${branch}"

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
  mkdir -p "${GIT_WORKDIR_PATH}/${repo}"
  sh /usr/share/doc/git/contrib/workdir/git-new-workdir \
    "${repo_path}" "${branch_path}" "${branch}"
fi

(cd ${branch_path};
  git stash
  git rebase origin/$branch
)
