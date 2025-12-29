# Defined in /var/folders/98/xl2cdk5x3bvf_3ckbfbc0zx40000gp/T//fish.TrdBg4/fish_user_key_bindings.fish @ line 1
function bind_bang
	switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end
