# Trying to lose the habit of using `git checkout`, by disabling it.
function git
  if [ $argv[1] = "checkout" ]
    echo "Stop using 'git checkout'. Instead, use these:"
    echo "- git switch     # for branches, create with -c"
    echo "- git restore    # for files"
    echo "Waiting 2 seconds as punishment"
    sleep 2
  end
  command git $argv
end
