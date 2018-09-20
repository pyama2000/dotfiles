# Defined in - @ line 0
function ghqd --description 'alias ghqd=cd (ghq root)/(ghq list | fzf)'
	cd (ghq root)/(ghq list | fzf) $argv;
end
