function srb
  if [ -f "./bin/srb" ]
    ./bin/srb $argv
  else
    command srb $argv
  end
end
