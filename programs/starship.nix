{ pkgs, ... }:

{
  enable = true;
  settings = {
    # "$schema" = "https://starship.rs/config-schema.json";
    add_newline = true;
    command_timeout = 500;
    continuation_prompt = "[∙](bright-black) ";
    format = "$shell$shlvl$nix_shell$username$hostname$localip$directory$git_branch$git_commit$git_state$git_metrics$git_status$docker_context$python$sudo$cmd_duration$line_break$time$status$character";
    right_format = "";
    scan_timeout = 30;
    
    character = {
        format = "$symbol ";
        vicmd_symbol = "[❮](bold green)";
        disabled = false;
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
    };
    cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
        style = "white bold";
        show_milliseconds = false;
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 45000;
    };
    directory = {
        disabled = false;
        fish_style_pwd_dir_length = 0;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        home_symbol = "~";
        read_only = " 📖";
        read_only_style = "red";
        repo_root_format = "[$before_root_path]($style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        style = "cyan bold bg:0xDA627D";
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        use_logical_path = true;
        use_os_path_sep = true;
    };
    directory.substitutions = {
        # Here is how you can shorten some long paths by text replacement;
        # similar to mapped_locations in Oh My Posh:;
        #"Documents" = "🗂️ ";
        #"Downloads" = "📥 ";
        #"Music" = "♪ ";
        #"Pictures" = "🖼️ ";
        # Keep in mind that the order matters. For example:;
        # "Important Documents" = "  ";
        # will not be replaced, because "Documents" was already substituted before.;
        # So either put "Important Documents" before "Documents" or use the substituted version:;
        # "Important  " = "  ";
        #"Important " = " ";
    };
    docker_context = {
        format = "[$symbol$context]($style) ";
        style = "blue bold bg:0x06969A";
        symbol = "🐳 ";
        only_with_files = false;
        disabled = false;
        detect_extensions = [];
        detect_files = [
        "docker-compose.yml"
        "docker-compose.yaml"
        "compose.yaml"
        "compose.yml"
        "Dockerfile"
        ];
        detect_folders = [
            "docker"
        ];
    };
    git_branch = {
        format = "[$branch(:$remote_branch)]($style) ";
        style = "bold purple bg:0xFCA17D";
        truncation_length = 9223372036854775807;
        truncation_symbol = "";
        only_attached = false;
        always_show_remote = false;
        ignore_branches = [];
        disabled = false;
    };
    git_commit = {
        commit_hash_length = 7;
        format = "[($hash$tag)]($style) ";
        style = "yellow bold";
        only_detached = true;
        disabled = false;
        tag_symbol = " ";
        tag_disabled = false;
    };
    git_metrics = {
        added_style = "bold green";
        deleted_style = "bold red";
        only_nonzero_diffs = true;
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
        disabled = false;
    };
    git_state = {
        disabled      = false;
        style         = "bold yellow";
        format        = "[$state $progress_current/$progress_total]($style) ";
        am            = "AM";
        am_or_rebase  = "AM/REBASE";
        bisect        = "BISECTING";
        cherry_pick   = "CHERRY-PICKING";
        merge         = "MERGING";
        rebase        = "REBASING";
        revert        = "REVERTING";
    };
    git_status = {
        disabled          = false;
        style             = "red bold bg:0xFCA17D";
        # list each status token with a space separator
        format   = "[$all_status]($style)";
        ahead             = "ahead $count ";
        behind            = "behind $count ";
        conflicted        = "conflicted ";
        deleted           = "deleted ";
        modified          = "modified ";
        renamed           = "renamed ";
        staged            = "staged ";
        stashed           = "stashed ";
        untracked         = "untracked ";
        up_to_date        = "up-to-date ";
        ignore_submodules = false;
    };
    hostname = {
        disabled = false;
        format = "[$ssh_symbol](blue dimmed bold)[$hostname]($style) ";
        ssh_only = true;
        style = "green dimmed bold";
        trim_at = ".";
    };
    localip = {
        disabled = false;
        format = "[@$localipv4]($style) ";
        ssh_only = true;
        style = "yellow bold";
    };
    memory_usage = {
        disabled = true;
        format = "$symbol[$ram( | $swap)]($style) ";
        style = "white bold dimmed";
        symbol = "💾 ";
        # threshold = 75;
        threshold = -1;
    };
    nix_shell = {
        format = "[$state( ($name))]($style) ";
        disabled = false;
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        style = "bold blue";
    };
    python = {
        format = "[$symbol$pyenv_prefix($version )(($virtualenv) )]($style)";
        python_binary = [
        "python"
        "python3"
        "python2"
        ];
        pyenv_prefix = "pyenv ";
        pyenv_version_name = true;
        style = "yellow bold";
        symbol = "🐍 ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = ["py"];
        detect_files = [
        "requirements.txt"
        ".python-version"
        "pyproject.toml"
        "Pipfile"
        "tox.ini"
        "setup.py"
        "__init__.py"
        ];
        detect_folders = [];
    };
    shell = {
        format = "[$indicator]($style) ";
        bash_indicator = "bsh";
        cmd_indicator = "cmd";
        elvish_indicator = "esh";
        fish_indicator = "";
        ion_indicator = "ion";
        nu_indicator = "nu";
        powershell_indicator = "_";
        style = "white bold";
        tcsh_indicator = "tsh";
        unknown_indicator = "mystery shell";
        xonsh_indicator = "xsh";
        zsh_indicator = "zsh";
        disabled = false;
    };
    shlvl = {
        threshold = 2;
        format = "[$symbol$shlvl]($style) ";
        symbol = "↕lv  ";
        repeat = false;
        style = "bold yellow";
        disabled = false;
    };
    status = {
        format = "[$symbol$status]($style) ";
        map_symbol = true;
        not_executable_symbol = "🚫";
        not_found_symbol = "🔍";
        pipestatus = false;
        pipestatus_format = "[$pipestatus] => [$symbol$common_meaning$signal_name$maybe_int]($style)";
        pipestatus_separator = "|";
        recognize_signal_code = true;
        signal_symbol = "⚡";
        style = "bold red bg:blue";
        success_symbol = "🟢 SUCCESS";
        symbol = "🔴 ";
        disabled = true;
    };
    sudo = {
        format = "[as $symbol]($style)";
        symbol = "🧙 ";
        style = "bold blue";
        allow_windows = false;
        disabled = false;
    };
    time = {
        format = "[$symbol $time]($style) ";
        style = "bold white bg:0x33658A";
        use_12hr = false;
        disabled = false;
        utc_time_offset = "local";
        # time_format = "%R"; # Hour:Minute Format;
        time_format = "%T"; # Hour:Minute:Seconds Format;
        time_range = "-";
    };
    username = {
        format = "[$user]($style) ";
        show_always = true;
        style_root = "red bold bg:0x9A348E";
        style_user = "green bold bg:0x9A348E";
        disabled = false;
    };
    };
    
}