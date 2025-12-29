set TERM 'xterm-256color'
set LANG en_US.UTF-8
set VISUAL vim
set EDITOR vim
set BAT_STYLE changes
# https://github.com/sharkdp/bat#output-style

set GOPATH ~/mygo

set TERM 'xterm-256color'
set fish_greeting ""
bind -s --preset '´' edit_command_buffer
bind -s --preset '√' edit_command_buffer

# PATH
# mbin
# kubectl stuff plugin install
set -x PATH $HOME/mbin $PATH 
# ~/mygo/bin
# $HOME/.krew/bin  
# /home/kit/.cargo/bin

# blink on ARLM signal
trap 'echo -en "\033[?5h"; sleep 0.2; echo -en "\033[?5l"' ALRM
# https://gist.github.com/jarun/4f7f3fba4618054d999463f242a4b5b9
# https://d12frosted.io/posts/2017-06-13-Fish-notify-me-when-you-finish.html
# https://mvolkmann.github.io/fish-article/
#

# recolor on HUP signal
trap 'recolor' HUP

trap 'say command ended of, $_; echo $_;' SIGUSR2
# trap 'say command ended of, $_; echo $_; echo end of $status: $_ | /home/kit/mbin/osd;' SIGUSR2
# https://stackoverflow.com/questions/69254700/how-to-get-the-full-current-command-in-fish-shell


# fish_add_path -a /xxx/bin

source "$HOME/.cargo/env.fish"

set BETTER_EXCEPTIONS 1
set FORCE_COLOR 1

