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
    done
    declare -A rule_copy_source=(
        ["AdBlock"]="AdBlock.list"
        ["Advertising"]="Advertising.list"
        ["AppStore"]="AppStore.list"
    )
    declare -A formats=(
        ["Egern"]="yaml"
        ["Singbox"]="json"
    )
    for target_rule in "${!rule_copy_source[@]}"; do
        source_file="ios_rule_script/rule/Clash/${copy_rule[$target_rule]}"
        for platform in "${!formats[@]}"; do
            output_file="$repository/$platform/$target_rule.${formats[$platform]}"
            for file in ${rule_copy_source[$target_rule]}; do
                cp "$source_file" "$output_file"
                echo "Processed: $source_file -> $output_file"
            done
            copy "$output_file" "${source_file[@]}"
        done
    done
    echo "$repository Repository: All Ruleset Processed!"
fi