#! /usr/bin/env sh

# Find out the target OS
if [ -s /etc/os-release ]; then
  # freedesktop.org and systemd
  . /etc/os-release
  OS=$NAME
  VER=$VERSION_ID
elif lsb_release -h >/dev/null 2>&1; then
  # linuxbase.org
  OS=$(lsb_release -si)
  VER=$(lsb_release -sr)
elif [ -s /etc/lsb-release ]; then
  # For some versions of Debian/Ubuntu without lsb_release command
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VER=$DISTRIB_RELEASE
elif [ -s /etc/debian_version ]; then
  # Older Debian/Ubuntu/etc.
  OS=Debian
  VER=$(cat /etc/debian_version)
elif [ -s /etc/SuSe-release ]; then
  # Older SuSE/etc.
  printf "TODO\n"
elif [ -s /etc/redhat-release ]; then
  # Older Red Hat, CentOS, etc.
  OS=$(cat /etc/redhat-release| head -n 1)
else
  RELEASE_INFO=$(cat /etc/*-release 2>/dev/null | head -n 1)

  if [ ! -z "$RELEASE_INFO" ]; then
    OS=$(printf "$RELEASE_INFO" | awk '{ print $1 }')
    VER=$(printf "$RELEASE_INFO" | awk '{ print $NF }')
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
  fi
fi

# Convert OS name to lowercase to remove inconsistencies
OS=$(printf "$OS" | awk '{ print tolower($1) }')

printf "%s" "$OS"

