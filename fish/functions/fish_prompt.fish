# Defined in /var/folders/98/xl2cdk5x3bvf_3ckbfbc0zx40000gp/T//fish.jLmMDD/fish_prompt.fish @ line 2

# https://fishshell.com/docs/3.1/cmds/fish_git_prompt.html
function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname)
    end

    if not set -q __fish_git_prompt_showstashstate
        set -g __fish_git_prompt_showstashstate 1
    end

    if not set -q __fish_git_prompt_char_stashstate
        set -g __fish_git_prompt_char_stashstate "s⚑"
    end

    if not set -q __fish_git_prompt_color_stashstate
        set -g __fish_git_prompt_color_stashstate red --bold
    end

    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 0
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end

    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch magenta --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream "informative"
    end
    if not set -q __fish_git_prompt_char_upstream_ahead
        set -g __fish_git_prompt_char_upstream_ahead "↑"
    end
    if not set -q __fish_git_prompt_char_upstream_behind
        set -g __fish_git_prompt_char_upstream_behind "↓"
    end
    if not set -q __fish_git_prompt_char_upstream_prefix
        set -g __fish_git_prompt_char_upstream_prefix ""
    end

    if not set -q __fish_git_prompt_char_stagedstate
        set -g __fish_git_prompt_char_stagedstate "●"
    end
    if not set -q __fish_git_prompt_char_dirtystate
        set -g __fish_git_prompt_char_dirtystate "✚"
    end
    if not set -q __fish_git_prompt_char_untrackedfiles
        set -g __fish_git_prompt_char_untrackedfiles "…"
    end
    if not set -q __fish_git_prompt_char_invalidstate
        set -g __fish_git_prompt_char_invalidstate "✖"
    end
    if not set -q __fish_git_prompt_char_cleanstate
        set -g __fish_git_prompt_char_cleanstate "✔"
    end

    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end
  
    # set_color F22
    # kubectl config current-context | tr '\n' '/'
    # kubens -c | tr '\n' ' '

    set -l color_cwd
    set -l prefix
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end
    echo -n '#'

    # PWD
    set_color 94F
    if [ $__fish_prompt_hostname = "xx-override-xxxx" ]
        echo -n "mac "
    else
        echo -n "$__fish_prompt_hostname "
    end
    set_color $color_cwd
    # https://fishshell.com/docs/current/cmds/prompt_pwd.html
    echo -n (prompt_pwd --full-length-dirs=2 --dir-length=2)
    set_color normal

    printf '%s ' (__fish_vcs_prompt)

    # branch stash
    if git bstash list > /dev/null
        set_color 96F
        echo -n "s⚑"
        set_color normal
    end

    if not test $last_status -eq 0
        set_color $fish_color_error
        echo -n "[$last_status] "
        set_color normal
    end

    echo -n "$suffix "
end
