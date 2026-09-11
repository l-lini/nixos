{ ... }:

{
  environment.shellAliases = {
    s = "git status";
    c = "git commit";
    a = "git add";
    p = "git push";
    u = "git pull";
    d = "git diff";
    l = "git log";
    restore = "git restore";
    switch = "git switch";
    checkout = "git checkout -b";
    merge = "git merge --squash";
    clone = "git clone";
  };

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      branch.main.mergeOptions = "--squash";
      push = {
        default = "simple";
        # autoSetupRemote = true;
      };
      pull = {
        rebase = true;
        autoStash = true;
      };
      url = {
        "https://github.com/" = {
          insteadOf = [
            "github:"
          ];
        };
      };
    };
  };
}
