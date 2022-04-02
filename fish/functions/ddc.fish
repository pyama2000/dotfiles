function ddc
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
end
