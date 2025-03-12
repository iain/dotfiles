function tapioca
  if [ -f "./bin/tapioca" ]
    ./bin/tapioca $argv
  else
    command tapioca $argv
  end
end
