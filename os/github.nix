{ secrets, pkgs, ... }:

{
  programs.git.config = {
    user = {
      name = "l-lini";
      email = "119787571+l-lini@users.noreply.github.com";
    };
    credential.helper = "!${pkgs.writeShellScript "git-cred" ''
      				echo "username=l-lini"
      				echo "password=${secrets.github}"
      			''}";
  };
}
