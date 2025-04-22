{
  # config
  krb5 = ./config/krb5.nix;
  users = ./config/users.nix;

  # settings
  fonts = ./settings/fonts.nix;
  gtk = ./settings/gtk.nix;
  soxin = ./soxin.nix;
  theme = ./settings/theme;
  usersImplementation = ./settings/users.nix;

  # programs
  alacritty = ./programs/alacritty.nix;
  astronvim = ./programs/astronvim;
  atuin = ./programs/atuin.nix;
  autorandr = ./programs/autorandr.nix;
  rbrowser = ./programs/rbrowser.nix;
  fzf = ./programs/fzf.nix;
  git = ./programs/git.nix;
  gpg = ./programs/gpg.nix;
  htop = ./programs/htop.nix;
  packages = ./programs/packages.nix;
  ssh = ./programs/ssh.nix;
  starship = ./programs/starship.nix;
  tmux = ./programs/tmux.nix;
  tmuxp = ./programs/tmuxp.nix;
  zsh = ./programs/zsh;

  # hardware
  intelBacklight = ./hardware/intel-backlight.nix;
  lowbatt = ./hardware/lowbatt.nix;
  rtl-sdr = ./hardware/rtl-sdr.nix;
  sound = ./hardware/sound.nix;
  yubikey = ./hardware/yubikey.nix;
  zsa = ./hardware/zsa.nix;

  # services
  caffeine-ng = ./services/caffeine-ng.nix;
  dunst = ./services/dunst.nix;
  easyeffects = ./services/easyeffects.nix;
  gpgAgent = ./services/gpg-agent.nix;
  i3 = ./services/x11/window-managers/i3;
  locker = ./services/locker.nix;
  picom = ./services/picom.nix;
  polybar = ./services/x11/window-managers/bar;
  printing = ./services/printing.nix;
  sshd = ./services/networking/ssh/sshd.nix;
  xserver = ./services/x11/xserver.nix;

  # virtualisation
  docker = ./virtualisation/docker.nix;
  libvirtd = ./virtualisation/libvirtd.nix;
}
