#!/bin/sh
#
# Opens the github page for a repo/branch in your browser.
#
# gh [remote] [branch]

git rev-parse --is-inside-work-tree 2>/dev/null

if [[ $? != 0 ]]
then
    echo "Not a git repository."
    exit 1
fi

remote="origin"
if [ ! -z "$1" ]
then
    remote="$1"
fi

remote_url="remote.${remote}.url"

giturl=$(git config --get $remote_url)
if [ -z "$giturl" ]
then
    echo "$remote_url not set."
    exit 1
fi

giturl=${giturl/git\@github\.com\:/https://github.com/}
giturl=${giturl%\.git}

if [ -z "$2" ]
then
    branch=`git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||'`
else
    branch="$2"
fi

if [ ! -z "$branch" ]
then
    giturl="${giturl}/tree/${branch}"
fi

# simplify URL for master
giturl=${giturl/tree\/master/}

open $giturl
exit 0
