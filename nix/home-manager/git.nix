{ pkgs, user, lib, config, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      # Include local configuration (user, email, etc.)
      include = {
        path = "~/.config/git/local/config";
      };

      core = {
        editor = "nvim";
        quotepath = false;
      };

      init = {
        defaultBranch = "main";
      };

      fetch = {
        prune = true;
      };

      pull = {
        rebase = false;
      };

      rebase = {
        autosquash = true;
      };

      # Commit template
      commit = {
        template = "~/.config/git/commit";
      };

      # Aliases
      alias = {
        icommit = "commit --allow-empty -m \"initial commit\"";
        empty = "commit --allow-empty -m \"empty commit\"";
        lograph = "log --graph --decorate --oneline --branches";
        logns = "log --graph --decorate --oneline --branches --name-status";
        ss = "status";
        adu = "add -u";
        adup = "add -u -p";
        br = "branch";
        bra = "branch --all";
        brm = "branch -m";
        brd = "branch -d";
        brdd = "branch -D";
        co = "commit";
        com = "commit -m";
        swc = "switch -c";
        swr = "!git fetch origin $1 && git switch";
        rs = "restore";
        rss = "restore --staged";
        mg = "merge --no-ff --no-edit";
        mgff = "merge --ff";
        rbrd = "push --delete origin";
        rmerged = "!f () { git switch $1; git branch --merged | egrep -v '\\*|develop|master' | xargs git branch -d; };f";
        cp = "cherry-pick";
        logmg = "log --merges --first-parent --oneline --pretty=format:\"%C(auto)%h%d %b %C(bold blue)<%an>%Creset\"";
        rve = "revert --no-edit";
        rvc = "revert --no-commit";
        cof = "commit --fixup";
      };
    };

    # Ignore file
    ignores = [
      ".envrc"
      ".myscript"
    ];
  };

  # Delta configuration (Top level program)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      plus-color = "#012800";
      minus-color = "#340001";
      syntax-theme = "Monokai Extended";
      line-numbers = true;
      navigate = true;
    };
  };

  # Deploy commit template using home.file
  home.file.".config/git/commit".text = ''
    # prefix
    # feat: A new feature
    # fix: A bug fix
    # docs: Documentation only changes
    # style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
    # refactor: A code change that neither fixes a bug nor adds a feature
    # perf: A code change that improves performance
    # test: Adding missing or correcting existing tests
    # chore: Changes to the build process or auxiliary tools and libraries such as documentation generation

    # ######## Emoji prefix ########
    # 👍 :+1:Improve the functionality
    # ✨ :sparkles: Introducing new features.
    # 🎉 :tada :Initial commit.
    # ♻️ :recycle: Refactoring code.
    # 🐛 :bug: Fixing a bug.
    # ✏️ :pencil2: Fixing types.
    # 🔖 :bookmark: Releasing / Version tags.
    # 🚨 :rotating_light: Removing linter warnings.
    # 🚧 :construction: Work in progress.
    # 🎨 :art: Improving structure / format of the code.
    # ⚡️ :zap: Improving performance.
    # 🔥 :fire: Removing code or files.
    # 🚚 :truck: Moving or renaming files.
    # 🚑 :ambulance: Critical hotfix.
    # 🔧 :wrench: Changing configuration files.
    # 🙈 :see_no_evil: Adding or updating a .gitignore file
    # ======== CI(Continuous Integration) ========
    # 💚 :green_heart: Fixing CI Build.
    # 👷 :construction_worker: Adding CI build system.
    # ======== Dependencies ========
    # ⬇️ :arrow_down: Downgrading dependencies.
    # ⬆️ :arrow_up: Upgrading dependencies.
    # 📌 :pushpin: Pinning dependencies to specific versions.
    # ➕ :heavy_plus_sign: Adding a dependency.
    # ➖ :heavy_minus_sign: Removing a dependency.
    # ======== Docker / Kubernetes ========
    # 🐳 :whale: Work about Docker.
    # ☸️ :wheel_of_dharma: Work about Kubernetes
    # ======== Document ========
    # 📚 :books: Writing docs.
    # 💡 :bulb: Documenting source code.
    # ======== Git ========
    # ⏪ :rewind: Reverting changes.
    # 🔀 :twisted_rightwards_arrows: Merging branches.
    # ======== others ========
    # 🚀 :rocket: Deploying stuff.
    # 💄 :lipstick: Updating the UI and style files.
    # ✅ :white_check_mark: Updating tests.
    # 🔒 :lock: Fixing security issues.
    # 💩 :hankey: Writing bad code that needs to be improved.
    # 📦 :package: Updating compiled files or packages.
    # 👽 :alien: Updating code due to external API changes.
    # 📄 :page_facing_up: Adding or updating license.
    # 💥 :boom: Introducing breaking changes.
    # 👌 :ok_hand: Updating code due to code review changes.
    # 🍻 :beers: Writing code drunkenly.
    # 💬 :speech_balloon: Updating text and literals.
    # 🗃 :card_file_box: Performing database related changes.
    # ======== ignored Emoji =========
    # 🍎🐧🏁🤖🍏📈🌐♿️🔊🔇👥🚸🏗📱🤡🥚📸⚗🔍🏷️
    # ##############################
  '';

  # Activation script to create local git config if it doesn't exist
  home.activation.createGitLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f /Users/${user}/.config/git/local/config ]; then
      run mkdir -p /Users/${user}/.config/git/local
      run touch /Users/${user}/.config/git/local/config
    fi
  '';
}
