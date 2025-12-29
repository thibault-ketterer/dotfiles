# function assemble_pdf
# { 
#         [ -z $1 ] && return 1
#         [ -z $2 ] && return 1
#         pdftk A=$1 B=$2 shuffle A B output $1-assembled.pdf
# } 
# 
function dedup_lines
        awk '!NF || !seen[$0]++'
end

alias yaml="yq r -C -d'*' -"

alias sum='awk "{s+=\$1} END {printf s}"'

alias jqlist=" jq '[paths | join(\".\")]' "

