# In ~/.zshrc define a PROJECT_PARENT_DIRS array and source this script. e.g.
# PROJECT_PARENT_DIRS=()
# PROJECT_PARENT_DIRS+=("$HOME/Projects")

for PARENT_DIR in ${PROJECT_PARENT_DIRS[@]} ; do
  if [ -d "$PARENT_DIR" ]; then
    for PROJECT_DIR in $(/bin/ls $PARENT_DIR); do
      if [[ ! -z `which $PROJECT_DIR 2> /dev/null` ]]; then
        if [ -d "$PARENT_DIR/$PROJECT_DIR" ]; then
          alias "$PROJECT_DIR"="cd $PARENT_DIR/$PROJECT_DIR"
        fi
      fi
    done
  fi
done
