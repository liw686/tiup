#!/bin/sh

repo='https://tiup-mirrors.pingcap.com'
case $(uname -s) in
    Linux|linux) os=linux ;;
    Darwin|darwin) os=darwin ;;
    *) os= ;;
esac

if [ -z "$os" ]; then
    echo "OS $(uname -s) not supported." >&2
    exit 1
fi

case $(uname -m) in
    amd64|x86_64) arch=amd64 ;;
    *) arch= ;;
esac

if [ -z "$arch" ]; then
    echo "Architecture  $(uname -m) not supported." >&2
    exit 1
fi

if [ -z "$TIUP_HOME" ]; then
    TIUP_HOME=$HOME/.tiup
fi
bin_dir=$TIUP_HOME/bin
mkdir -p "$bin_dir"
if ! curl "$repo/tiup-$os-$arch.tar.gz" | tar -zx -C "$bin_dir"; then
    echo "Failed to download and/or extract tiup archive."
    exit 1
fi

chmod 755 "$bin_dir/tiup"

echo "$SHELL"
case $SHELL in
    *bash*) PROFILE=$HOME/.bash_profile;;
     *zsh*) PROFILE=$HOME/.zshrc;;
         *) PROFILE=$HOME/.profile;;
esac

bold=$(tput bold 2>/dev/null)
sgr0=$(tput sgr0 2>/dev/null)

case :$PATH: in
    *:$bin_dir:*) : "PATH already contains $bin_dir" ;;
    *) printf 'export PATH=%s:$PATH\n' "$bin_dir" >> "$PROFILE"
        echo "$PROFILE has been modified to to add tiup to PATH"
        echo "open a new terminal or ${bold}source ${PROFILE}${sgr0} to use it"
        ;;
esac

echo "tiup is installed in $bin_dir/tiup"