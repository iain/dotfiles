function sidekiq
  if [ -f "./bin/sidekiq" ]
    ./bin/sidekiq $argv
  else
    command sidekiq $argv
  end
end
