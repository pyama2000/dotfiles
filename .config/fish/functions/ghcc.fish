function ghcc
  set DIRECTORY_NAME $argv[1]
  ghq create $DIRECTORY_NAME
  eval "cd" (ghq list --full-path --exact $DIRECTORY_NAME)
end
