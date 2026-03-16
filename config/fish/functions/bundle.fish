function bundle
  if [ -f "./bin/bundle" ]
    ./bin/bundle $argv
  else
    command bundle $argv
  end
end
