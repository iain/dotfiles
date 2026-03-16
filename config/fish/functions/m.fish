function m
  if [ -z "$argv" ]
    mvim --remote-tab-silent .
  else
    mvim --remote-silent $argv
  end
end
