#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

rm -rf ios_rule_script
git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

echo "Execute in $repository Repository"

mkdir -p "$repository"/{Egern,Singbox}
for dir in Egern Singbox; do
    find ios_rule_script/rule/Clash -type f -name "*.list" -exec cp --parents {} "$repository/$dir/" \;
done

echo "Copied all rules to $repository/Egern and $repository/Singbox"
echo "$repository Repository: All Ruleset Processed!"