function tnew
  set SESSION_NAME $argv[1]
  tmux new -s $SESSION_NAME -d
  tmux switch-client -t $SESSION_NAME
end
