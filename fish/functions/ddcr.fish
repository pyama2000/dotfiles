function ddcr
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run --rm -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
end
