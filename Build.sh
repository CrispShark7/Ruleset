#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

if [[ "$repository" == "Ruleset" ]]; then
    rule_dirs=("Egern" "Singbox")
    for rule_path in "${rule_dirs[@]}"; do
        mkdir -p "$repository/$rule_path"
    done
    declare -A rule_local_source=(
        ["AdBlock"]="AdBlock.list"
        ["Advertising"]="Advertising.list"
        ["AppStore"]="AppStore.list"
    )
    declare -A formats=(
        ["Egern"]="yaml"
        ["Singbox"]="json"
    )
    for target_rule in "${!rule_local_source[@]}"; do
        for platform in "${!formats[@]}"; do
            output_file="$repository/$platform/Ruleset/$target_rule.${formats[$platform]}"
            source_urls=(); source_file=()
            for file in ${rule_local_source[$target_rule]}; do
                source_urls+=("https://raw.githubusercontent.com/Centralmatrix3/Scripts/master/Ruleset/$file")
                source_file+=("$repository/Ruleset/$file")
            done
            copy "$output_file" "${source_file[@]}"
        done
    done
    echo "$repository Repository: All Ruleset Processed!"
fi