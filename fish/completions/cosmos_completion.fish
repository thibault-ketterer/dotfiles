# # 
# function _generate_cosmos_completions
#     set -l cur (commandline -ct)
#     set -l prev (commandline -ct)
#     set -l cmd (commandline -opc)[1]
#     set -l command ""
#     set -l subcommand ""
#     set -l tokens (commandline -opc)
# 
#     for i in (seq 2 (count $tokens))
#         if not string match -qr "^-" -- $tokens[$i]
#             if test -z "$command"
#                 set command $tokens[$i]
#             else if test -z "$subcommand"
#                 set subcommand $tokens[$i]
#                 break
#             end
#         end
#     end
# 
#     set -l opts
#     set -l descs
#     if test -n "$subcommand"
#         set opts ($cmd $command $subcommand --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) print $1}')
#         set -a opts ($cmd $command $subcommand --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
#         set descs ($cmd $command $subcommand --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
#     else if test -n "$command"
#         set opts ($cmd $command --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) print $1}')
#         set -a opts ($cmd $command --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
#         set descs ($cmd $command $subcommand --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
#     else
#         set opts ($cmd --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) print $1}')
#         set -a opts ($cmd --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
#         set descs ($cmd $command $subcommand --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
#     end
# 
#     set -l filtered_opts
# #    set -l index 1
#     for opt in $opts
#         if string match -qr -- "^$cur" -- $opt
#             if not contains -- $opt $filtered_opts
#                 set filtered_opts $filtered_opts $opt
#             end
#         end
#     end
# 
#     for opt in $filtered_opts
#         echo $opt
#     end
# end
# 
# for bin in namadac namadan namadaw namada osmosisd gaiad entangled artelad lavad 
#     complete -c $bin -f -a '(_generate_cosmos_completions)'
# end

#
function _generate_cosmos_completions
    set -l cmd (commandline -opc)[1]
    complete -c cmd --erase
    set -l tokens (commandline -opc)

    set -l command ""
    set -l subcommand ""

    for i in (seq 2 (count $tokens))
        if not string match -qr "^-" -- $tokens[$i]
            if test -z "$command"
                set command $tokens[$i]
            else if test -z "$subcommand"
                set subcommand $tokens[$i]
                break
            end
        end
    end

    set -l opts
    # set -l descs
    if test -n "$subcommand"
        set opts ($cmd $command $subcommand --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
        # set descs ($cmd $command $subcommand --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
    else if test -n "$command"
        set opts ($cmd $command --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) print $1}')
        set -a opts ($cmd $command --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
        # set descs ($cmd $command --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) { for (i=2; i<=NF; i++) printf "%s ", $i; print "" }}')
        # set -a descs ($cmd $command --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
    else
        # set descs ($cmd --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) { for (i=2; i<=NF; i++) printf "%s ", $i; print "" }}')
        # set -a descs ($cmd --help 2>/dev/null | awk 'BEGIN {RS="--"; FS="\n"} NR>1 {print $1}')
        set opts ($cmd --help 2>/dev/null | awk '/Commands:/,/^$/ {if (!/:/ && !/^$/ && $1) print $1}')
        set -a opts ($cmd --help 2>/dev/null | string match -r '\-\-[a-zA-Z0-9\-]+')
    end


    set -l index 1
    # set -l desc
    for opt in $opts
        # set desc (string trim -c " " (echo $descs[$index]))
        echo "$opt"
        # dynamic completion won't work becasue complete is a cumulative fonction :(
        #if test -n "$subcommand"
        #    complete -c $cmd -f -n "__fish_seen_subcommand_from $subcommand" -o "$opt" -d "$desc"
        #else if test -n "$command"
        #    complete -c $cmd -f -n "__fish_seen_subcommand_from $command" -o "$opt" -d "$desc"
        #else
        # complete -c $cmd -f -a "$opt" -d "$desc"
        # end
        # set index (math $index + 1)
    end

end

for bin in namadac namadan namadaw namada osmosisd gaiad entangled artelad lavad
    complete -c $bin -f -a '(_generate_cosmos_completions)'
end

