#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

rm -rf ios_rule_script
git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

echo "Execute in $repository Repository"

rm -rf "$repository"/Egern/* "$repository"/Singbox/*
mkdir -p "$repository"/{Egern,Singbox}

while IFS= read -r -d '' file; do
    rel_path="${file#ios_rule_script/rule/Clash/}"

    dest="$repository/Egern/${rel_path%.list}.yaml"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"

    dest="$repository/Singbox/${rel_path%.list}.json"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
done < <(find ios_rule_script/rule/Clash -type f -name "*.list" -print0)

echo "Copied and renamed all rules to $repository/Egern and $repository/Singbox"
echo "$repository Repository: All Ruleset Processed!"