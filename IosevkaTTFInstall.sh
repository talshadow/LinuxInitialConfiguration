#/bin/bash

pushd /tmp
TTF_VERSION='33.2.2'
TTFS=PkgTTF-IosevkaFixedSS08-$TTF_VERSION.zip
wget https://github.com/be5invis/Iosevka/releases/download/v$TTF_VERSION/$TTFS
unzip -d ./IosevkaFixedSS08 $TTFS
sudo cp -r ./IosevkaFixedSS08 /usr/share/fonts/truetype/
fc-cache -f -v
popd
