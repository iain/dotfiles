function fish_title
    # Tag every terminal/tab title with the short host, so it is obvious which
    # machine a Ghostty tab is driving — local or remote. Fish's default only
    # tags SSH sessions (leaving local tabs unlabelled); this extends it to all
    # tabs while keeping the default's command + directory layout.
    set -l host (prompt_hostname | string sub -l 12)
    set -l cmd $argv
    set -q cmd[1]; or set cmd (status current-command)
    test "$cmd" = fish; and set cmd
    echo -- "[$host]" (string sub -l 20 -- $cmd) (prompt_pwd -d 1 -D 1)
end
