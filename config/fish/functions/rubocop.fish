function rubocop
  if [ -f "./bin/rubocop" ]
    ./bin/rubocop $argv
  else
    command rubocop $argv
  end
end
