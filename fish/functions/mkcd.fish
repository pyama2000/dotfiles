function mkcd
  set DIRECTORY_NAME $argv[1]
  mkdir -p $DIRECTORY_NAME
  eval "cd" $DIRECTORY_NAME
end
