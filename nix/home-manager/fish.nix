{
  pkgs,
  lib,
  user,
  config,
  ...
}:

let
  # Function definitions extracted from legacy files
  ddc = ''
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
  '';

  ddcr = ''
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run --rm -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
  '';

  ghcc = ''
    set DIRECTORY_NAME $argv[1]
    ghq create $DIRECTORY_NAME

    if [ -n "$DIRECTORY_NAME" ]
      eval "cd (ghq list --full-path --exact $DIRECTORY_NAME)"
    end
  '';

  ghcd = ''
    set DIRECTORY_NAME $argv[1]

    if [ -n "$DIRECTORY_NAME" ]
      eval "cd (ghq list --full-path --exact $DIRECTORY_NAME)"
    else
      eval "cd (ghq list --full-path | fzf)"
    end
  '';

  ghrm = ''
    set DIRECTORY_NAME $argv[1]

    if [ -n "$DIRECTORY_NAME" ]
      rm -rf (ghq list --full-path --exact $DIRECTORY_NAME)
    else
      rm -rf (ghq list --full-path | fzf)
    end
  '';

  mkcd = ''
    set DIRECTORY_NAME $argv[1]
    mkdir -p $DIRECTORY_NAME
    eval "cd" $DIRECTORY_NAME
  '';

  tnew = ''
    set SESSION_NAME $argv[1]
    tmux new -s $SESSION_NAME -d
    tmux switch-client -t $SESSION_NAME
  '';

in
{
  programs.fish = {
    enable = true;

    # 引数を後ろに続けるプレフィックス型の省略形は abbr にします
    # （入力時に展開されるため、履歴に完全なコマンドが残ります）。
    shellAbbrs = {
      # ghq
      ghg = "ghq get";
      ghl = "ghq list";
      # cargo
      rfmt = "cargo fmt";
      cch = "cargo check --color=always";
      clippy = "cargo clippy";
      # Docker
      dc = "docker compose";
      # terraform
      tf = "terraform";
    };

    # それ自体で完結するコマンド、および関数・コマンド置換から参照されるものは alias のままにします。
    shellAliases = {
      # exa
      exaf = "eza --long --all --group-directories-first --bytes --header --group --git";
      exat = "eza --all --group-directories-first --group --git --tree --ignore-glob .git";
      # fzf + bat（fpre は fvim がコマンド置換で参照するため abbr にできない）
      fpre = "fzf --preview \"bat --color=always {}\"";
      fvim = "nvim (fpre)";
      # pipenv
      piid = "pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black";
    };

    # Functions
    functions = {
      inherit
        ddc
        ddcr
        ghcc
        ghcd
        ghrm
        mkcd
        tnew
        ;
    };

    # Interactive Shell Init
    interactiveShellInit = ''
      ${lib.optionalString pkgs.stdenv.isDarwin "eval (/opt/homebrew/bin/brew shellenv)"}

      # Reportedly zoxide/eza not found. Adding Nix binary paths explicitly.
      fish_add_path /run/current-system/sw/bin
      fish_add_path /etc/profiles/per-user/${user}/bin
      fish_add_path $HOME/.nix-profile/bin

      ##############################
      # aqua                       #
      ##############################
      set -x XDG_DATA_HOME "$HOME/.local/share"
      set -x AQUA_ROOT_DIR "$XDG_DATA_HOME/aquaproj-aqua"
      set -x AQUA_GLOBAL_CONFIG "$HOME/dotfiles/aqua.yaml"
      fish_add_path "$AQUA_ROOT_DIR/bin"

      ##############################
      # config                     #
      ##############################
      set fish_greeting ""
      set -gx LC_ALL ja_JP.UTF-8
      set -gx LC_TYPE ja_JP.UTF-8
      set -gx LANG ja_JP.UTF-8
      fish_add_path /usr/local/sbin
      fish_add_path $HOME/.local/bin

      ##############################
      # Python                     #
      ##############################
      set -x PIPENV_VENV_IN_PROJECT 1

      ##############################
      # Go                         #
      ##############################
      set -x GOPATH $HOME/go
      fish_add_path $HOME/go/bin

      ##############################
      # Rust                       #
      ##############################
      fish_add_path $HOME/.cargo/bin

      ##############################
      # fzf                        #
      ##############################
      set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

      ##############################
      # direnv                     #
      ##############################
      set -x EDITOR nvim

      ##############################
      # lima（macOS の docker VM 用）#
      ##############################
      ${lib.optionalString pkgs.stdenv.isDarwin "set -x LIMA_INSTANCE docker"}

      ##############################
      # docker                     #
      ##############################
      set -x DOCKER_BUILDKIT 1

      ##############################
      # Theme                      #
      ##############################
      set -l foreground DCD7BA
      set -l selection 2D4F67
      set -l comment 727169
      set -l red C34043
      set -l orange FF9E64
      set -l yellow C0A36E
      set -l green 76946A
      set -l purple 957FB8
      set -l cyan 7AA89F
      set -l pink D27E99

      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment

      # bun
      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH
    '';
  };
}
