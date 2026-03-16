function rails
  if [ -f "./bin/rails" ]
    ./bin/rails $argv
  else
    command rails $argv
  end
end
