# Defined in /var/folders/98/xl2cdk5x3bvf_3ckbfbc0zx40000gp/T//fish.TrdBg4/fish_user_key_bindings.fish @ line 10
function bind_dollar
	switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
