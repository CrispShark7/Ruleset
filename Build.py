#!/usr/bin/env python3

import json
import sys
import argparse
from pathlib import Path
from collections import defaultdict

EGERN_RULE_MAP = {
    "DOMAIN": "domain_set",
    "DOMAIN-SUFFIX": "domain_suffix_set",
    "DOMAIN-KEYWORD": "domain_keyword_set",
    "DOMAIN-WILDCARD": "domain_wildcard_set",
    "IP-CIDR": "ip_cidr_set",
    "IP-CIDR6": "ip_cidr6_set",
    "IP-ASN": "asn_set",
    "GEOIP": "geoip_set"
}
EGERN_RULE_QUOTE = {"domain_wildcard_set"}

SINGBOX_RULE_MAP = {
    "DOMAIN": "domain",
    "DOMAIN-SUFFIX": "domain_suffix",
    "DOMAIN-KEYWORD": "domain_keyword",
    "IP-CIDR": "ip_cidr",
    "IP-CIDR6": "ip_cidr"
}

def rules_load(file_path: Path):
    rule_data = []
    for line in file_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split(",", 2)
        while len(parts) < 3:
            parts.append("")
        rule_data.append(tuple(parts[:3]))
    return rule_data

def rules_write(file_path, rule_name, rule_count, rule_data, platform):
    if platform == "Singbox":
        with file_path.open("w", encoding="utf-8", newline="\n") as f:
            json.dump(rule_data, f, indent=2, ensure_ascii=False)
            f.write("\n")
    else:
        with file_path.open("w", encoding="utf-8", newline="\n") as f:
            f.write(f"# 规则名称: {rule_name}\n")
            f.write(f"# 规则统计: {rule_count}\n\n")
            f.writelines(f"{line}\n" for line in rule_data)
    if platform:
        print(f"Processed ({platform}): {file_path}")

def process_egern(file_path):
    rule_name = file_path.stem
    parsed = rules_load(file_path)
    rule_data = defaultdict(list)
    no_resolve = False
    for style, value, field in parsed:
        if style not in EGERN_RULE_MAP:
            continue
        if field == "no-resolve":
            no_resolve = True
        rule_type = EGERN_RULE_MAP[style]
        rule_value = f'"{value}"' if rule_type in EGERN_RULE_QUOTE else value
        rule_data[rule_type].append(rule_value)
    output = ["no_resolve: true"] if no_resolve else []
    for rule_type, rule_list in rule_data.items():
        output.append(f"{rule_type}:")
        output.extend(f"  - {value}" for value in rule_list)
    rule_count = sum(line.startswith("  - ") for line in output)
    rules_write(file_path, rule_name, rule_count, output, "Egern")

def process_singbox(file_path, enable_type=False, enable_order=False):
    rule_name = file_path.stem
    parsed = rules_load(file_path)
    rule_data = defaultdict(list)
    for style, value, field in parsed:
        if style not in SINGBOX_RULE_MAP:
            continue
        rule_type = SINGBOX_RULE_MAP[style]
        rule_data[rule_type].append(value)
    rule_list = [{rule_type: value} for rule_type, value in rule_data.items()]
    output = {"version": 3, "rules": rule_list}
    rules_write(file_path, None, None, output, platform="Singbox")

def main():
    parser = argparse.ArgumentParser(description="规则构建工具")
    parser.add_argument("platform", choices=["Egern", "Singbox"])
    parser.add_argument("file_path", type=Path, help="规则文件或者路径")
    args = parser.parse_args()
    platform_map = {"Egern": process_egern, "Singbox": process_singbox}
    process_func = platform_map[args.platform]
    if args.file_path.is_file():
        files_to_process = [args.file_path]
    elif args.file_path.is_dir():
        if args.platform == "Singbox":
            files_to_process = sorted(args.file_path.rglob("*.json"))
        else:
            files_to_process = sorted(args.file_path.rglob("*.list"))
    else:
        sys.exit(f"{args.file_path} not found or unsupported type.")
    if not files_to_process:
        print(f"No supported files found in: {args.file_path}")
        return
    for f in files_to_process:
        try:
            process_func(f)
        except Exception as e:
            print(f"Failed to process {f}: {e}")
    print("Processed Completed.")

if __name__ == "__main__":
    main()