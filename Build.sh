#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"


rm -rf ios_rule_script
curl -sL https://github.com/blackmatrix7/ios_rule_script/archive/refs/heads/master.zip -o master.zip
unzip -q master.zip
mv ios_rule_script-master ios_rule_script
rm master.zip

echo "Execute in $repository Repository"
mkdir -p "$repository"/{Egern,Singbox}

# 一次性复制 Clash 下所有内容到 Egern 和 Singbox
cp -r ios_rule_script/rule/Clash/* "$repository"/Egern/
cp -r ios_rule_script/rule/Clash/* "$repository"/Singbox/

echo "Copied All Rule to $repository/Egern and $repository/Singbox"
echo "$repository Repository: All Ruleset Processed!"