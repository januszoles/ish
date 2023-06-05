#!/bin/sh

# fix /etc/apk/repositories

echo "==> Change to Alpine Linux repositories"
echo "--- Old /etc/apk/repositories ---"
cat /etc/apk/repositories
echo "---"
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/main >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories
sed -i -e '/http:\/\/apk.ish.app/d' /etc/apk/repositories
echo "--- New /etc/apk/repositories ---"
cat /etc/apk/repositories
echo "---"
apk update
apk upgrade
