#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

rm -rf ios_rule_script

git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

if [[ "$repository" == "Ruleset" ]]; then
    echo "Execute in $repository Repository"
    rule_dirs=("Egern" "Singbox")
    for rule_path in "${rule_dirs[@]}"; do
        mkdir -p "$repository/$rule_path"
        cp -r ios_rule_script/rule/Clash/* "$repository/$rule_path/"
        echo "Copied all rules to $repository/$rule_path"
    done
    echo "$repository Repository: All Ruleset Processed!"
fi