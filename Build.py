import os
import shutil
from git import Repo

# 1. 克隆仓库
source_url = "https://github.com/blackmatrix7/ios_rule_script.git"
repo_dir = "ios_rule_script"

if os.path.isdir(repo_dir):
    shutil.rmtree(repo_dir)

Repo.clone_from(source_url, repo_dir, quiet=True)

# 2. 路径
clash_dir = os.path.join(repo_dir, "rule", "Clash")
target_dir = "Egern"

os.makedirs(target_dir, exist_ok=True)

# 3. 递归遍历 Clash，只处理 .list 文件
for root, dirs, files in os.walk(clash_dir):
    for file in files:
        if not file.endswith(".list"):
            continue

        src = os.path.join(root, file)

        # 保留 Clash 以下的相对目录结构
        rel_path = os.path.relpath(root, clash_dir)
        dst_dir = os.path.join(target_dir, rel_path)

        os.makedirs(dst_dir, exist_ok=True)
        shutil.copy2(src, os.path.join(dst_dir, file))
