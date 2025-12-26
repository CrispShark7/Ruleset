#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

echo "Execute in $repository Repository"

rm -rf ios_rule_script
git clone -q --depth=1 https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

rm -rf "$repository"/{Egern,Singbox}
mkdir -p "$repository"/{Egern,Singbox}

while IFS= read -r -d '' file; do
    rel_path="${file#ios_rule_script/rule/Clash/}"
    base_dir="$(basename "$(dirname "$rel_path")")"
    egern_target="$repository/Egern/$base_dir/${base_dir}.yaml"
    mkdir -p "$(dirname "$egern_target")"
    [ ! -f "$egern_target" ] && cp "$file" "$egern_target"
    singbox_target="$repository/Singbox/$base_dir/${base_dir}.json"
    mkdir -p "$(dirname "$singbox_target")"
    [ ! -f "$singbox_target" ] && cp "$file" "$singbox_target"
done < <(find ios_rule_script/rule/Clash -type f -name "*.list" -print0)

#while IFS= read -r -d '' file; do
#    rel_path="${file#ios_rule_script/rule/Clash/}"
#    rel_dir="$(dirname "$rel_path")"
#    mkdir -p "$repository/Egern/$rel_dir" "$repository/Singbox/$rel_dir"
#    cp "$file" "$repository/Egern/${rel_path%.list}.yaml"
#    cp "$file" "$repository/Singbox/${rel_path%.list}.json"
#done < <(find ios_rule_script/rule/Clash -mindepth 1 -type f -name "*.list" -print0)
#done < <(find ios_rule_script/rule/Clash -mindepth 2 -maxdepth 2 -type f -name "*.list" -print0)

echo "$repository Repository: All Ruleset Processed!"