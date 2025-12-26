#!/usr/bin/env bash

set -euo pipefail

repository="$(basename "$GITHUB_REPOSITORY")"

rm -rf ios_rule_script
git clone -q https://github.com/blackmatrix7/ios_rule_script.git ios_rule_script

echo "Execute in $repository Repository"

# 创建目标目录
mkdir -p "$repository"/{Egern,Singbox}

# 递归处理 .list 文件，同时复制并改名
while IFS= read -r -d '' file; do
    # 获取相对路径
    rel_path="${file#ios_rule_script/rule/Clash/}"
    
    # 目标路径：Egern -> .yaml
    dest="$repository/Egern/${rel_path%.list}.yaml"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"

    # 目标路径：Singbox -> .json
    dest="$repository/Singbox/${rel_path%.list}.json"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"

done < <(find ios_rule_script/rule/Clash -type f -name "*.list" -print0)

echo "Copied and renamed all rules to $repository/Egern and $repository/Singbox"
echo "$repository Repository: All Ruleset Processed!"