function ghcc
  set DIRECTORY_NAME $argv[1]
  ghq create $DIRECTORY_NAME

  if [ -n "$DIRECTORY_NAME" ]
    eval "cd (ghq list --full-path --exact $DIRECTORY_NAME)"
  end
end
