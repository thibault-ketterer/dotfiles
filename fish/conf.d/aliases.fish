# set -U EDITOR vim
# TODO ~/.config/fish/functions/ for every function...
alias cal='ncal -b'
alias lt="ls -lrt"
alias lu="ls -lru"
alias l="ls -l"
# arch
functions -e dig
which dig >/dev/null || alias dig="drill"

function process
	#    for i in (pgrep fish | grep -v $fish_pid); ls -l /proc/$i/cwd| awk '{print $NF}'| pstree -T -p $i ; end |sort -u 
    for i in (pgrep fish | grep -v $fish_pid); ls -l /proc/$i/cwd| awk '{print $NF}';pstree -T -p $i;echo ; end

end

function shells
    for i in (pgrep fish | grep -v $fish_pid); ls -l /proc/$i/cwd| awk '{print $NF}'; end | grep -v $HOME'$' |sort -u 
end

function realias
	for f in ~/.config/fish/conf.d/aliases.*.fish ~/.config/fish/conf.d/aliases.fish
		echo "loading $f"
		source $f
	end
	echo end
end

# vim
alias vo='vim -c ":MRU"'
alias vialias='vim ~/.config/fish/conf.d/aliases.fish; realias'
alias k='kubectl'

function bd
    set PREVOLDPWD $OLDPWD
    set OLDPWD $PWD
    set NEWPWD (echo $OLDPWD | sed 's|\(.*/'$argv[1]'[^/]*/\).*|\1|')
    set index (echo $NEWPWD | awk '{ print index($0,"/'$argv[1]'"); }')
    if [ $index = 0 ]
        echo "No such occurrence."
        set OLDPWD $PREVOLDPWD
        return
    end
    echo $NEWPWD
    cd "$NEWPWD"
end

# fix missing !$ !! in fish

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# function fish_user_key_bindings
#     bind ! bind_bang
#     bind '$' bind_dollar
# end

function fish_user_key_bindings
  fish_hybrid_key_bindings
  bind -M insert ! bind_bang
  bind -M insert '$' bind_dollar
end

function setcopy
    if [ ! -z "$WAYLAND_DISPLAY" ]
        alias copy="timeout 1 wl-copy -f"
        # supposed to work with wl-copy -o but it's not
    else if type -q pbcopy
        alias copy="pbcopy -general "
    else if type -q xclip
        alias copy="xclip -selection clipboard 2>/dev/null"
    else if type -q copyq
	  alias copy='copyq copy - '
    else if type -q xsel
        # Silence error so no error message shows up
        # if e.g. X isn't running.
        alias copy="xsel --clipboard 2>/dev/null"
    end
end

setcopy


function clip2png
	# xclip -selection clipboard -t image/png -o > $1.png
    if [ ! -z "$WAYLAND_DISPLAY" ];
        wl-paste > $argv[1].png
    else
	    copyq read image/png 0 > $argv[1].png
    end
end


function join_by
    echo (string join $argv[1] $argv[2..-1])
end

# GREP_COLORS='mt=00;34;01' hl 'vpn-only@' |  GREP_COLORS='mt=00;33;41' hl 'vpn@'
function hl
    if not status is-interactive >>/dev/null;
        cat;
        return;
    end
    set sav $GREP_COLOR
    set -x GREP_COLORS 'mt=00;38;5;226'
    # deprecated
    # set GREP_COLOR '00;38;5;226';
    # set pipes (join_by '|' $argv)
    set -l pipes (string join '|' $argv)
    grep -E -i --color=always "$pipes"'|$';
    set GREP_COLOR $sav
end

function where
    if isatty stdout;
	    find . -iname "*$argv[1]*" |grepand $argv[2..] | hl "$argv[1]"
    else
	    find . -iname "*$argv[1]*" |grepand $argv[2..]
    end
end

function v
    if test -f "$argv[1]";
        vim $argv[1]
        # title_vim $argv[1]
    else;
        # set fname (v_helper_2 $argv|string split0) #no break newlines
        # set fnames (v_helper_2 $argv) #with break newlines
        set fname (v_helper_3 $argv|string split0) #no break newlines
        set fnames (v_helper_3 $argv) #with break newlines
        # echo "fname [$fname]"
        if test (echo "$fname" |wc -l) -gt 1
        # if string match '*'\cM $fname;
            # echo "multiple match:";
            # printf "$fname\n" | hl $argv;
            set -l chosen (/usr/bin/python3 ~/mbin/vselect.py $fnames)
            echo $chosen
            vim $chosen
        else;
            echo "open vim [$fname]"
            eval vim "$fname" #need to get rid of newline hack
        end
        set -e fname fnames
    end
end

# function vnew
# 	x-terminal-emulator -e "vim $argv" &
# 	disown
# end

function grepand
    set -l awk_call "";
    set -l awk_call "/$argv[1]/";
    for i in $argv;
        set awk_call "$awk_call && /$i/";
    end
    awk "$awk_call" | hl $argv
end

function etpf
    cat ~/.eternal_history | grepand $argv | less +G -R -r
end

function etpfcat
    cat ~/.eternal_history | grepand $argv
end

function etpf2
    grep --text $argv ~/.eternal_history | less +G -R -r
end

function vimwhich
# should I write vim ~/mbin/$argv[1] ? no cause fish give aliases file
    $EDITOR (type -s $argv[1] | awk '{print $NF}' | tr -d "\`'()")
end

# function alarmat
# 	set -l T $argv[1]
# 	[ -z $T ] && return
#         set -l say_string (string replace -a ' ' ',' $argv[2])
# 	echo "export DISPLAY=:0 ; notify-send 'remindme: $argv[2]';say $say_string; notify-send 'remindme: $argv[2]';notify-send 'remindme: $argv[2]' & mplayer -really-quiet ~/mp3/alarm.mp3" | at "$T"
# 	echo ALARM set for "[$argv[2]]"
# 	echo "export DISPLAY=:0 ; notify-send 'remindme: $argv[2]';say $say_string; notify-send 'remindme: $argv[2]';notify-send 'remindme: $argv[2]' & mplayer -really-quiet ~/mp3/alarm.mp3" 
# end

function alarmin
	set -l IN $argv[1]
	[ -z $IN ] && return
        set T (date -d "now +$IN minutes" +%H%M)
	alarmat $T $argv[2]
end


alias cutit='cut -b 1-$COLUMNS'
alias rgrep='grep -r'

function cdt
    cd (ls -rtd */ | tail -1)
end

function mkcd
    mkdir $argv[1] && cd $argv[1]
end

function locate
	locate $argv |hl $argv
end

alias h='history'

function recent
    set -l MTIME $argv[1];
    [ -z $MTIME ] && set -l MTIME 2;
    find . -mtime -{$MTIME} -type f -not -path './*/.*' -and -not -path './.*'
end

alias pcopy='pwd | copy'

function hcopy
	if [ -z "$argv[1]" ]
		set n 1
        else
		set n $argv[1]
        end
	history -$n --max 1
	history -$n --max 1 | copy
end

# alias hcopy='history -1 | copy'
alias hfile='history -1 > '

# TODO could be refactored with the next one duplicated code
# execute the last command again and pass it through grep
function regrep
	set -l grep_arg "$argv"
	if test -z "$grep_arg"
		set grep_arg "."
	end
	# set -l cmd (history -1)
	set -l hist1 (history -1)
	set -l relaunch "true"
	echo "hist val ['$hist1]"
	if string match -r '^regrep' "$hist1" > /dev/null;
		set relaunch "false"
	end
	if string match -r '^regain' "$hist1" > /dev/null;
		set relaunch "false"
	end
	echo "relaunch [$relaunch]"
	if [ "$relaunch" = "true" ];
		set -g tmpregain (mktemp)
		echo "launching [$hist1]"
		echo "" | eval $hist1 |\
			string replace --all -r '\\e\\[[0-9m;]+' '' |\
			string replace --all -r '\\e\\[.' '' > $tmpregain
	else
		echo "not lauching again"
	end

 	# echo "$tmpregain"
 	# cat "$tmpregain"
 	# TODO multiple join_by |  regain 'templa\|mo'
	grep "$grep_arg" "$tmpregain"
	set -g fl (grep --color=no "$grep_arg" $tmpregain)
        # echo "$tmpregain" copied to clipboard
        # echo $tmpregain | copy
        # vim $tmpregain

	# remove regain file
	if [ "$relaunch" = "true" ];
		set -l IN 10
	        set T (date -d "now +$IN minutes" +%H%M)
		# alarmat $T $argv[2]
		echo "export DISPLAY=:0 ; rm $tmpregain; notify-send 'tmpregain removed [$tmpregain]'; " | at "$T" > /dev/null 2>&1
	end
end


# execute the last command again
function regain
	set -l hist1 (history -1)
	set -l relaunch "true"
	echo "hist val ['$hist1]" >&2
	if string match -r '^regrep' "$hist1" > /dev/null;
		set relaunch "false"
	end
	if string match -r '^regain' "$hist1" > /dev/null;
		set relaunch "false"
	end
	echo "re [$relaunch]" >&2
	if [ "$relaunch" = "true" ];
		set -g tmpregain (mktemp)
		echo "launching [$hist1]" >&2
		echo "" | eval $hist1 |\
			string replace --all -r '\\e\\[[0-9m;]+' '' |\
			string replace --all -r '\\e\\[.' '' > $tmpregain
	else
		echo "not lauching again" >&2
	end

 	cat "$tmpregain"
	# fl is a global var for output
	set -g fl (cat $tmpregain)

	# remove regain file
	if [ "$relaunch" = "true" ];
		set -l IN 10
	        set T (date -d "now +$IN minutes" +%H%M)
		# alarmat $T $argv[2]
		echo "export DISPLAY=:0 ; rm $tmpregain; notify-send 'tmpregain removed [$tmpregain]'; " | at "$T" > /dev/null 2>&1
	end
end

# function vimgain
# 	set -l tmpfile (mktemp)
# 	# set -l cmd (history -1)
# 	eval (history -1) > $tmpfile
#  	#      echo $tmpfile
# 	cat $tmpfile | grep $argv
# 	set -g fl (cat $tmpfile | grep $argv)
# 
#         echo "$fl" copied to clipboard
#         echo "$fl" | copy
#         vim $fl
# 
# 	set -l IN 10
#         set T (date -d "now +$IN minutes" +%H%M)
# 	# alarmat $T $argv[2]
# 	echo "export DISPLAY=:0 ; rm $tmpfile; notify-send 'tmpfile removed [$tmpfile]';say 'file removed' " | at "$T" > /dev/null
# end

# launch command on last command output
function regaindo
	regain
	echo $argv" $fl"
	$argv $fl
end

# function regainvim
# 	regain
#         echo "$fl"
# 	vim "$fl"
# end

# edit outpout of last command in vim
function regainedit
	regain
        echo "$tmpregain"
	vim "$tmpregain"
end

function prefix
	[ -z $argv[1] ] && return
	rename -v "s/^/$argv[1]-/" "$argv[2]"
end

function todoaddl
	printf "\n"(date +%F:%T)"	$argv\n" >> TODO.md
end

function tododd
	printf "\n"(date +%F:%T)"	$argv\n" >> ~/TODO.md
end

# # TODO make it persist with Xdefaults
# function changecolor
# 	set color ""
# 	if [ ! -z "$argv[1]" ]
# 		set color $argv[1]
# 		echo -en "\033]11;$color\007\033]10;gray\007"
# 		ubgtext $color color
# 		pkill -HUP fish
# 		return
#         end
# 	if test -f /tmp/.rv
# 		echo -en '\033]11;black\007\033]10;gray\007'
# 		ubgtext black color
# 		rm -f /tmp/.rv
# 		pkill -HUP fish
# 	else
# 		echo -en '\033]11;#ffffff\007\033]10;black\007'
# 		ubgtext white color
# 		touch /tmp/.rv
# 		pkill -HUP fish
# 	end
# end
# 
# 
# function recolor
# 	if test -f /tmp/.rv
# 		echo -en '\033]11;#ffffff\007\033]10;black\007'
# 		#ubgtext white color
# 	else
# 		echo -en '\033]11;black\007\033]10;gray\007'
# 		#ubgtext black color
# 	end
# end


function awklast
	awk '{print $NF}'
end


alias lzd='lazydocker'

function waitfor
  # http://stackoverflow.com/questions/645992/bash-sleep-until-a-specific-time-date                                     
  if [ -z $argv[1] ]; return; end
  if [ -z $argv[2] ]; return; end
  set -l current_epoch (date +%s)
  set -l target_epoch (date -d "$argv[1]:$argv[2]:00" +%s)           
  set -l sleep_seconds (math $target_epoch - $current_epoch )
  if test $sleep_seconds -lt 0; set sleep_seconds (math "$sleep_seconds + 24 * 3600"); end
  echo sleep $sleep_seconds
  if [ $sleep_seconds -lt 0 ]; return 1; end
  sleep $sleep_seconds
end

function whatport
	sudo netstat -pant |grepand LISTEN :$argv[1]
end


# spt search  'not unusual' --tracks
alias td='date +%F_%H_%M_%S'

#alias kgiga='kubectl config set-context giga --namespace=monitoring && kubectl config use-context giga'
alias cd..="cd .."

function realfile
	echo (readlink -f .)/$argv
end
alias bat="bat --theme=(test ! -e /tmp/.rv && echo default || echo GitHub)"
alias clean="rm -vf *~ \#*\# *.pyc"
function colx
	awk '{print $'$argv'}'
end
function jqfull
    # jq 'paths(scalars) as $p
	# | $p + [getpath($p)]
	# | join(".")' | rev | sed -e 's/\./=/' | rev
    jq 'paths(scalars) as $p 
    | "\($p | join("."))=\(getpath($p))"'
end



function swap
    if [ -z $argv[1] ]; echo "help: swap A B"; return; end
    if [ -z $argv[2] ]; echo "help: swap A B"; return; end
    set A "$argv[1]"
    set B "$argv[2]"
    if test -f $A -a -f $B
	    set type "files"
    else if test -d $A -a -d $B
	    set type "dirs"
    else
	    return "help: swap A and B (has to be dir or files)"
    end
    echo "swapping $type [$A] and [$B]"
    mv -v $A tmp_file_swap_inprogress_former_$A &&\
    mv -v $B $A &&\
    mv -v tmp_file_swap_inprogress_former_$A $B
end


alias docker_get_entrypoint="docker inspect --format='{{.Config.Entrypoint}}' "
alias stripcolors="sed -r 's/\x1B\[[0-9;]*[mK]//g'"
alias Grep=grep
alias rm_venv='rm -r ./bin ./lib ./include ./pyvenv.cfg'

alias daaaaaat="watch -n0.01 -t -d 'date +%F-%T-%N | cut -b 1-22'"
function zi
  cd "$(z -l | sort -rn | awk '{$1=""; print substr($0,2)}' | fzf)" 
end

