# ~/Documents/02_Code/sh-scripts/add_example_script.sh
#!/bin/zsh

# Check if the correct number of arguments are provided
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <script_name> <description> [<command_name>]"
  exit 1
fi

SCRIPT_NAME=$1
DESCRIPTION=$2
COMMAND_NAME=${3:-cmd}

SCRIPT_PATH=~/Documents/02_Code/sh-scripts/$COMMAND_NAME/$SCRIPT_NAME.sh
CSV_PATH=~/Documents/02_Code/sh-scripts/$COMMAND_NAME/scripts.csv

# Create the new script file
echo "#!/bin/zsh\n\necho \"$DESCRIPTION\"" > $SCRIPT_PATH

# Add execute permission
chmod +x $SCRIPT_PATH

# Update the CSV file
if [[ -f $CSV_PATH ]]; then
  echo "$SCRIPT_NAME,$DESCRIPTION" >> $CSV_PATH
else
  echo "script_name,description" > $CSV_PATH
  echo "$SCRIPT_NAME,$DESCRIPTION" >> $CSV_PATH
fi

echo "Script '$SCRIPT_NAME.sh' created in '$COMMAND_NAME' directory and CSV updated."
