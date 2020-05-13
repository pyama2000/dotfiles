function ghrm
  set DIRECTORY_NAME $argv[1]

  if [ -n "$DIRECTORY_NAME" ]
    rm -rf (ghq list --full-path --exact $DIRECTORY_NAME
  else
    rm -rf (ghq list --full-path | fzf)
  end
end
