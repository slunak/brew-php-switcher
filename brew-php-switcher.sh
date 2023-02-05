#!/usr/bin/env sh

declare -a php_versions

version=$(php -v | grep -o -e "PHP [0-9+]\.[0-9+]" | cut -d " " -f2)
php_versions=($(brew ls --versions | egrep "^php(\ |@)" | cut -d " " -f2 | grep -o -e "[0-9+]\.[0-9+]" | xargs))

if [[ -z "$1" ]]; then
    php_versions=$(printf ", %s" "${php_versions[@]}")
    echo "Simple script to switch quickly between major versions of PHP installed via Homebrew"
    echo
    echo "Usage: brew-php-switcher <version>"
    echo
    echo "    Where version is one of:" ${php_versions:2}
    echo "    Current PHP version:" ${version}
    exit 0
fi

version_found=0
for php_version in ${php_versions[@]}; do
  if [ "${php_version}" = "$1" ]; then
    version_found=1
    break
  fi
done

if [ ${version_found} = 0 ]; then
  echo "Specified PHP version $1 is not installed."
  exit 1
fi

if [ "${version}" = "$1" ]; then
  echo "Cannot change PHP to the same version."
  exit 1
fi

echo "Switching to PHP $1"
echo
brew unlink php
brew link "php@$1" --force --overwrite
echo
echo "All done!"
