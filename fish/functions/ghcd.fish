function ghcd
  set DIRECTORY_NAME $argv[1]

  if [ -n "$DIRECTORY_NAME" ]
    eval "cd (ghq list --full-path --exact $DIRECTORY_NAME)"
  else
    eval "cd (ghq list --full-path | fzf)"
  end
end
