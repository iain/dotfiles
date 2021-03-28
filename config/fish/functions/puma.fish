function puma
  if [ -f "./bin/puma" ]
    ./bin/puma $argv
  else
    command puma $argv
  end
end
