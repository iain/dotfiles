function yarn
  if [ -f "./bin/yarn" ]
    ./bin/yarn $argv
  else
    command yarn $argv
  end
end
