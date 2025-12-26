#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

echo "Execute in $repository Repository"

rm -rf ios_rule_script
git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

rm -rf "$repository"/{Egern,Singbox}
mkdir -p "$repository"/{Egern,Singbox}

while IFS= read -r -d '' file; do
    rel_path="${file#ios_rule_script/rule/Clash/}"
    rel_dir="$(dirname "$rel_path")"
    mkdir -p "$repository/Egern/$rel_dir" "$repository/Singbox/$rel_dir"
    cp "$file" "$repository/Egern/${rel_path%.list}.yaml"
    cp "$file" "$repository/Singbox/${rel_path%.list}.json"
done < <(find ios_rule_script/rule/Clash -mindepth 1 -type f -name "*.list" -print0)

echo "Copied and renamed all rules to $repository/Egern and $repository/Singbox"
echo "$repository Repository: All Ruleset Processed!"