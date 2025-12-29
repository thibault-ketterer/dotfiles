
if status --is-interactive
	function sync_history --on-event fish_preexec
		echo "$fish_pid $USER  fish  "(date +%F:%T) " $argv" >> ~/.eternal_history
	end
end
