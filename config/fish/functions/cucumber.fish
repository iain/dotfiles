function cucumber
  if [ -f "./bin/cucumber" ]
    ./bin/cucumber $argv
  else
    command cucumber $argv
  end
end
