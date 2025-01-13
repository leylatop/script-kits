#!/bin/bash

# 添加进度条函数
show_progress() {
  local current=$1
  local total=$2
  local width=50 # 进度条宽度
  local percentage=$((current * 100 / total))
  local completed=$((width * current / total))
  local remaining=$((width - completed))

  printf "\033[K["
  printf "%${completed}s" | tr ' ' '#'
  printf "%${remaining}s" | tr ' ' '-'
  printf "] %d/%d (%d%%)\r" "$current" "$total" "$percentage"
}

# 修改输出目录为运行脚本的目录下的output-YYYYMMDDHHMMSS
OUTPUT_DIR=$(dirname "$0")/output-$(date +%Y%m%d%H%M%S)

# 检查并创建输出目录
init_output_dirs() {
  if [ ! -d "$OUTPUT_DIR" ]; then
    sudo mkdir -p "$OUTPUT_DIR"
    sudo chmod 777 "$OUTPUT_DIR"
  fi
}

# 检查URL状态码的函数
check_url() {
  local url=$1
  local http_code
  local timestamp

  http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
    echo -e "\033[32m[${http_code}]\033[0m $url"
    echo "[$timestamp] $url - HTTP状态码: $http_code" >>"$OUTPUT_DIR/$http_code.log"
  elif [ "$http_code" -ge 300 ] && [ "$http_code" -lt 400 ]; then
    echo -e "\033[33m[${http_code}]\033[0m $url"
    echo "[$timestamp] $url - HTTP状态码: $http_code" >>"$OUTPUT_DIR/$http_code.log"
  else
    echo -e "\033[31m[${http_code}]\033[0m $url"
    echo "[$timestamp] $url - HTTP状态码: $http_code" >>"$OUTPUT_DIR/$http_code.log"
  fi
}

# 主程序
main() {
  # 初始化输出目录
  init_output_dirs

  # 检查参数
  if [ $# -eq 0 ]; then
    echo "使用方法: $0 urls.txt"
    echo "urls.txt 应包含每行一个URL"
    exit 1
  fi

  # 检查文件是否存在
  if [ ! -f "$1" ]; then
    echo "错误: 文件 '$1' 不存在"
    exit 1
  fi

  local total_lines
  local current_line=0
  local total=0

  # 首先计算总行数（排除空行和注释行）
  total_lines=$(grep -v '^$\|^#' "$1" | wc -l)

  # 读取文件中的每个URL并检查
  echo "开始检查URL..."
  echo "------------------------"

  while IFS= read -r url || [ -n "$url" ]; do
    # 跳过空行和注释行
    [[ -z "$url" || "$url" =~ ^#.*$ ]] && continue

    ((current_line++))
    # echo -e "\033[K正在处理: $current_line/$total_lines 行 ($((current_line * 100 / total_lines))%)\r"
    show_progress "$current_line" "$total_lines"
    
    ((total++))
    check_url "$url"

  done <"$1"
  echo

  # 输出统计信息
  echo "------------------------"
  echo "检查完成!"
  echo "总计: $total"
}

# 运行主程序
main "$@"
