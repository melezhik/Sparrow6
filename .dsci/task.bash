pwshell_distr="https://github.com/PowerShell/PowerShell/releases/download/v7.3.7/powershell-7.3.7-linux-arm64.tar.gz"

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export DEBIAN_FRONTEND=noninteractive
export TZ=Etc/UTC

sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq tzdata

sudo apt-get update -yq

sudo apt-get install -yq \
ruby-dev ruby-bundler \
python3-pip python3-dev python3-pytest \
carton cpanminus \
libc6 \
libgcc1 \
libgcc-s1 \
libgssapi-krb5-2 \
libicu74 \
liblttng-ust1 \
libssl3 \
libstdc++6 \
libunwind8 \
zlib1g \
php

# Download the powershell '.tar.gz' archive

curl -L -o /tmp/powershell.tar.gz $pwshell_distr

# Create the target folder where powershell will be placed
sudo mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
sudo tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
sudo chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
pwsh --version

cd ../

zef install --/test Tomty

zef install . --force-install

s6 --index-update

tomty --profile=ci --all --show-failed --color

