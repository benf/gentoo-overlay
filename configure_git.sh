#!/bin/bash

#origin (default push to both: overlays.gentoo.org and github, fetch from gentoo)
git config --replace-all remote.origin.url     git://git.overlays.gentoo.org/user/benf.git
git config --replace-all remote.origin.pushurl git+ssh://git@git.overlays.gentoo.org/user/benf.git
git config --add         remote.origin.pushurl git@github.com:benf/gentoo-overlay

# overlays.gentoo.org
git config --replace-all remote.gentoo.url     git://git.overlays.gentoo.org/user/benf.git
git config --replace-all remote.gentoo.pushurl git+ssh://git@git.overlays.gentoo.org/user/benf.git

# github
git config --replace-all remote.github.url     git://github.com/benf/gentoo-overlay.git
git config --replace-all remote.github.pushurl git@github.com:benf/gentoo-overlay.git


# master branch
git config branch.master.remote origin
git config branch.master.merge refs/heads/master
