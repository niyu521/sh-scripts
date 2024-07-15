# ~/Documents/02_Code/sh-scripts/zsh/_cmd
#compdef cmd

_cmd() {
  local -a scripts
  scripts=(${(f)"$(ls ~/Documents/02_Code/sh-scripts/cmd/*.sh 2>/dev/null)"})
  scripts=(${scripts:t:r})  # スクリプト名のみにする

  _describe -t scripts 'script' scripts
}

compdef _cmd cmd
