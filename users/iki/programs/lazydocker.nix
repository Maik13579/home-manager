{ ... }:
{
  enable = true;
  settings = {
    gui.theme = {
      activeBorderColor = [
        "red"
        "bold"
      ];
      inactiveBorderColor = [ "blue" ];
    };
    commandTemplates.dockerCompose = "docker compose"; # Lazydocker uses docker-compose by default which will not work
  };
}
