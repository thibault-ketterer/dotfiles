
# GIT
#
function gitmassci
    while true
        git citool;
        sleep 0.5;
    end
end

# alias gitmaster='git fetch && git co master && git reset --hard origin/master && git co -'
alias gitmasterstash='git stash && git fetch && git co master && git pull && git co - && git stash pop'
alias gitmaster='git fetch && git co master && git pull && git co -'
alias gitreset='git fetch && git reset --hard origin/$GIT_BRANCH'

