# In ~/.zshrc define a PROJECT_PARENT_DIRS array and source this script. e.g.
# PROJECT_PARENT_DIRS=()
# PROJECT_PARENT_DIRS+=("$HOME/Projects")

if [ -z "${PROJECT_PARENT_DIRS[*]}" ]; then
  echo "Define a PROJECT_PARENT_DIRS array in ~/.bash_profile"
fi

for PARENT_DIR in ${PROJECT_PARENT_DIRS[@]} ; do
  if [ -d "$PARENT_DIR" ]; then
    for PROJECT_DIR in $(/bin/ls $PARENT_DIR); do
      found=`wich $PROJECT_DIR 2> /dev/null`
      if [ -z $found ]; then
        if [ -d "$PARENT_DIR/$PROJECT_DIR" ]; then
          alias "$PROJECT_DIR"="cd $PARENT_DIR/$PROJECT_DIR"
        fi
      fi
    done
  fi
done
