#!/bin/bash

# 旧地址
old_url="git@mdgit.300624.cn"
# 新地址
new_url="git@git.modao.ink"

changed_count=0
base_dir="MockingBot"
for file in ${base_dir}/**/.git/config; do 
  # 使用old_url替换new_url
  sed -i '' "/\[remote \"origin\"\]/,/^\[.*\]/ s|url = ${old_url}|url = ${new_url}|g" "$file"
  sed -i '' "/\[remote \"origin\"\]/,/^\[.*\]/ s|url = ${old_url}|url = ${new_url}|g" "$file"
  echo "修改 $file 成功"
  changed_count=$((changed_count + 1))
done

# 使用find命令查看当前目录下的子文件夹数量
echo "当前目录下的子文件夹数量: $(find ${base_dir}/ -maxdepth 1 -type d | wc -l)"
echo "总共修改了 $changed_count 个文件"

