#!/bin/bash

rm -rf ../hvigor/*.tgz

rm -rf dist/

pluginVersion=$(sed -n "s/.*VERSION = '\([^']*\)'.*/\1/p" ./src/BuildConfig.ts)

pluginVersionContent="  \"version\": \"$pluginVersion\","

harClassContent="export const HAR_VERSION = '$pluginVersion';"
harPackageContent="  \"version\": \"$pluginVersion\","

sed -i '' "3s|.*|$pluginVersionContent|" "package.json"
sed -i '' "3s|.*|$harPackageContent|" "../therouter/oh-package.json5"
sed -i '' "4s|.*|$harClassContent|" "../therouter/BuildProfile.ets"

echo "当前编译版本号：${pluginVersion}"

npm run build

npm pack

timestamp=$(date +"%Y%m%d%H%M%S")

echo "$timestamp.tgz"

mv *.tgz  ../hvigor/"$timestamp".tgz

sed -i '' "4s|.*|    \"@therouter/plugin\": \"file:./$timestamp.tgz\"|" "../hvigor/hvigor-config.json5"

debugContent=$(sed -n '5p' ../hvigor/hvigor-config.json5)
if [[ "$debugContent" == *"//"* ]]; then
  debugContent="${debugContent//\/\//}"
fi
debugContent="$(echo "$debugContent" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
sed -i '' "5s|.*|//    $debugContent  |" "../hvigor/hvigor-config.json5"

rm -rf dist/