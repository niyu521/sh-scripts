
# カスタムコマンドスクリプトマネージャー

このガイドは、`cmd`コマンドを使用して新しいコマンドやスクリプトを追加する方法を説明する。

## 前提条件

- `zsh`がインストールされ、デフォルトのシェルとして設定されていることを確認する。
- `cmd`コマンドとその環境が正しく設定されていることを確認する。

## ディレクトリ構造

```
~/Documents/02_Code/sh-scripts/
├── cmd
│   ├── cmd
│   ├── scripts.csv
│   ├── example.sh
│   └── ...
└── zsh
    └── _cmd
```

## 新しいコマンド[example]を追加する場合

### 1. コマンドスクリプトを作成する

新しいコマンドを追加するには、`example`ディレクトリに新しいシェルスクリプトを作成する。

例: `example.sh`

```sh
# ~/Documents/02_Code/sh-scripts/example/example.sh
#!/bin/zsh
echo "これはexampleのスクリプトです。"
```

### 2. 実行権限を追加する

新しいスクリプトに実行権限があることを確認する。

```sh
chmod +x ~/Documents/02_Code/sh-scripts/example/example.sh
```

### 3. CSVファイルを更新する

`scripts.csv`ファイルに新しいスクリプトのエントリと簡単な説明を追加する。

```csv
script_name,description
example,これはexampleのスクリプトです
```

### 4. 補完スクリプトの作成

新しいコマンドの補完スクリプトを作成する。

```sh
# ~/Documents/02_Code/sh-scripts/zsh/_example
#compdef example

_example() {
  local -a scripts
  scripts=(${(f)"$(ls ~/Documents/02_Code/sh-scripts/example/*.sh 2>/dev/null)"})
  scripts=(${scripts:t:r})  # スクリプト名のみにする

  _describe -t scripts 'script' scripts
}

compdef _example example
```

### 5. `.zshrc` の設定を更新

`.zshrc` ファイルに以下の設定を追加する。

```sh
# ~/.zshrc
export PATH=$PATH:~/Documents/02_Code/sh-scripts/example
fpath=(~/Documents/02_Code/sh-scripts/zsh $fpath)
autoload -Uz compinit && compinit
```

### 6. zshの再読み込み

設定ファイルを保存し、zshを再読み込みする。

```sh
source ~/.zshrc
```

### 7. コマンドを確認する

`example -h`を実行して、新しいコマンドがリストに表示されることを確認する。

```sh
example -h
```

### 8. コマンドをテストする

新しいコマンドを実行して、正しく動作するか確認する。

```sh
example example
```

## コマンド[example]で実行できるスクリプトを追加する場合

### 1. スクリプトを作成する

`example`ディレクトリに新しいスクリプトファイルを作成する。

例: `example-new-feature.sh`

```sh
# ~/Documents/02_Code/sh-scripts/example/example-new-feature.sh
#!/bin/zsh
echo "これはexampleコマンドの新機能スクリプトです。"
```

### 2. 実行権限を追加する

新しいスクリプトに実行権限があることを確認する。

```sh
chmod +x ~/Documents/02_Code/sh-scripts/example/example-new-feature.sh
```

### 3. CSVファイルを更新する

`scripts.csv`ファイルに新しいスクリプトのエントリと簡単な説明を追加する。

```csv
script_name,description
example-new-feature,これはexampleコマンドの新機能スクリプトです
```

### 4. スクリプトを確認する

`example -h`を実行して、新しいスクリプトがリストに表示されることを確認する。

```sh
example -h
```

### 5. スクリプトをテストする

新しいスクリプトを実行して、正しく動作するか確認する。

```sh
example example-new-feature
```

## 新しいスクリプトを追加するためのワンライナー

### 1. スクリプトを作成

以下のスクリプトを `~/Documents/02_Code/sh-scripts/` ディレクトリに保存する。

```sh
# ~/Documents/02_Code/sh-scripts/add-script.sh
#!/bin/zsh

# 引数の数が正しいかチェックする
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <script_name> <description> [<command_name>]"
  exit 1
fi

SCRIPT_NAME=$1
DESCRIPTION=$2
COMMAND_NAME=${3:-cmd}

SCRIPT_PATH=~/Documents/02_Code/sh-scripts/$COMMAND_NAME/$SCRIPT_NAME.sh
CSV_PATH=~/Documents/02_Code/sh-scripts/$COMMAND_NAME/scripts.csv

# 新しいスクリプトファイルを作成する
echo "#!/bin/zsh

echo "$DESCRIPTION"" > $SCRIPT_PATH

# 実行権限を追加する
chmod +x $SCRIPT_PATH

# CSVファイルを更新する
if [[ -f $CSV_PATH ]]; then
  echo "$SCRIPT_NAME,$DESCRIPTION" >> $CSV_PATH
else
  echo "script_name,description" > $CSV_PATH
  echo "$SCRIPT_NAME,$DESCRIPTION" >> $CSV_PATH
fi

echo "Script '$SCRIPT_NAME.sh' created in '$COMMAND_NAME' directory and CSV updated."
```

### 2. 実行権限を追加する

スクリプトに実行権限を付与する。

```sh
chmod +x ~/Documents/02_Code/sh-scripts/add-script.sh
```

### 3. 新しいスクリプトを追加する

新しいスクリプトを追加するには、以下のコマンドを実行する。

```sh
~/Documents/02_Code/sh-scripts/add-script.sh <script_name> <description> [<command_name>]
```

- `script_name`: 新しいスクリプトの名前
- `description`: スクリプトの説明
- `command_name` (オプション): コマンド名（指定しない場合はデフォルトで `cmd`）

#### 例1: `cmd` デフォルトコマンドで新しいスクリプトを追加

```sh
./add-script.sh example-new-feature "これはexampleの新機能スクリプトです"
```

#### 例2: `example` コマンドで新しいスクリプトを追加

```sh
./add-script.sh example-new-feature "これはexampleの新機能スクリプトです" example
```

### 実行後の確認

スクリプトを実行した後、以下のコマンドで新しいスクリプトが作成され、CSVファイルが更新されていることを確認する。

```sh
cmd -h
cmd example-new-feature

# 例: exampleコマンドで追加した場合
example -h
example example-new-feature
```

## 注意点

- `cmd`スクリプトと`_cmd`補完スクリプトが`.zshrc`ファイルに正しく設定されていることを確認する。

```sh
# ~/.zshrc
export PATH=$PATH:~/Documents/02_Code/sh-scripts/cmd
fpath=(~/Documents/02_Code/sh-scripts/zsh $fpath)
autoload -Uz compinit && compinit
```

- 変更を加えた後に`.zshrc`を再読み込みする。

```sh
source ~/.zshrc
```

これらの手順に従うことで、カスタムコマンドスクリプトマネージャーに新しいコマンドやスクリプトを簡単に追加できる。
