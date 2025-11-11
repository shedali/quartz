run:
	xc "`xc  -s | fzf --preview 'xc  -d {} | mdcat'`"
