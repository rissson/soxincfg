{
  # config
  krb5 = ./config/krb5.nix;
  users = ./config/users.nix;

  # settings
  fonts = ./settings/fonts.nix;
  gtk = ./settings/gtk.nix;
  soxin = ./soxin.nix;
  usersImplementation = ./settings/users.nix;

  # programs
  alacritty = ./programs/alacritty.nix;
  astronvim = ./programs/astronvim;
  atuin = ./programs/atuin.nix;
  fzf = ./programs/fzf.nix;
  git = ./programs/git.nix;
  gpg = ./programs/gpg.nix;
  htop = ./programs/htop.nix;
  packages = ./programs/packages.nix;
  rbrowser = ./programs/rbrowser.nix;
  ssh = ./programs/ssh.nix;
  starship = ./programs/starship.nix;
  sway = ./programs/sway.nix;
  swaylock = ./programs/swaylock.nix;
  tmux = ./programs/tmux.nix;
  tmuxp = ./programs/tmuxp.nix;
  waybar = ./programs/waybar.nix;
  zsh = ./programs/zsh;

  # hardware
  intelBacklight = ./hardware/intel-backlight.nix;
  rtl-sdr = ./hardware/rtl-sdr.nix;
  sound = ./hardware/sound.nix;
  yubikey = ./hardware/yubikey.nix;
  zsa = ./hardware/zsa.nix;

  # services
  displayManager = ./services/display-manager.nix;
  dunst = ./services/dunst.nix;
  easyeffects = ./services/easyeffects.nix;
  gpgAgent = ./services/gpg-agent.nix;
  hypridle = ./services/hypridle.nix;
  kanshi = ./services/kanshi.nix;
  locker = ./services/locker.nix;
  printing = ./services/printing.nix;
  sshd = ./services/networking/ssh/sshd.nix;
  swww = ./services/swww.nix;

  # virtualisation
  docker = ./virtualisation/docker.nix;
  libvirtd = ./virtualisation/libvirtd.nix;
}
