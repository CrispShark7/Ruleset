#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"
rm -rf ios_rule_script
git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

if [[ "$repository" == "Ruleset" ]]; then
    echo "Execute in $repository Repository"
    mkdir -p "$repository"/{Egern,Singbox}
    cp -r ios_rule_script/rule/Clash/* "$repository"/Egern/
    cp -r ios_rule_script/rule/Clash/* "$repository"/Singbox/
    echo "Copied All Rule to $repository/Egern and $repository/Singbox"
    echo "$repository Repository: All Ruleset Processed!"
fi