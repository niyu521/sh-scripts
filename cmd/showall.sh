# display_all_files.sh
#!/bin/zsh

# こんな感じで使用できる
# cmd show-all-contents -d 1

# デフォルトの深さを2に設定
depth=2

# オプションを解析
while getopts "d:" opt; do
  case ${opt} in
    d )
      depth=$OPTARG
      ;;
    \? )
      echo "Usage: cmd [-d depth]"
      exit 1
      ;;
  esac
done

# ツリー構造を表示する関数
display_tree() {
  local current_depth=$1
  local max_depth=$2
  local current_dir=$3
  local indent=$4

  # カレントディレクトリ以下の全ファイルを探索
  for file in "$current_dir"/*; do
    if [[ -d "$file" ]]; then
      echo "${indent}$(basename "$file")/"
      if [[ $current_depth -lt $max_depth ]]; then
        display_tree $((current_depth+1)) $max_depth "$file" "  $indent"
      fi
    elif [[ -f "$file" ]]; then
      echo "${indent}$(basename "$file")"
    fi
  done
}

# ファイルを再帰的に表示し、その内容を表示する関数
display_files() {
  local current_depth=$1
  local max_depth=$2
  local current_dir=$3

  # カレントディレクトリ以下の全ファイルを探索
  for file in "$current_dir"/*; do
    if [[ -f "$file" ]]; then
      echo "Displaying contents of: $file"
      cat "$file"
      echo ""
    elif [[ -d "$file" && $current_depth -lt $max_depth ]]; then
      echo "Entering directory: $file"
      display_files $((current_depth+1)) $max_depth "$file"
    fi
  done
}

# 現在のディレクトリからツリー構造を表示
echo "Directory Tree:"
display_tree 1 $depth "." ""

# `-d`オプションについての解説を表示
echo ""
echo "Option -d: Specify the depth to search for files."
echo "Usage: cmd [-d depth]"
echo "Example: cmd -d 3"
echo ""
echo "オプション -d: ファイルを探索する階層を指定します。"
echo "使用方法: cmd [-d depth]"
echo "例: cmd -d 3"
echo ""

# 現在のディレクトリから探索を開始
display_files 1 $depth "."
