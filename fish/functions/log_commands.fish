# Defined interactively
function log_commands --on-event fish_preexec
    # fish_preexec functions receive the commandline as the argument (see `function --help`)
    date +"%F:%T $argv" >> ~/.eternal_history 
end
