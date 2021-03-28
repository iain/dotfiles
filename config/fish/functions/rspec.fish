function rspec
  if [ -f "./bin/rspec" ]
    ./bin/rspec $argv
  else
    command rspec $argv
  end
end
