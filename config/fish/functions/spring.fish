function spring
  if [ -f "./bin/spring" ]
    ./bin/spring $argv
  else
    command spring $argv
  end
end
