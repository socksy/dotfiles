with import <nixpkgs> { };

buildFHSUserEnv {
  name = "enter-fhs";
  targetPkgs = pkgs: with pkgs; [
    alsaLib
    appimage-run
    atk
    at-spi2-atk
    at-spi2-core
    bash
    cabal-install
    cairo
    clojure
    cups
    dbus
    direnv
    dpkg
    docker-compose
    electron
    emacs
    expat
    file
    firefox
    fontconfig
    freetype
    fuse
    go
    gcc
    #godep
    gnumake
    gdb
    git
    glib
    glibc
    gnome2.GConf
    gnome3.gdk_pixbuf
    gnome3.libgnome-keyring
    gnome3.libsecret
    gtk2
    gtk3
    jansson
    keychain
    leiningen
    libffi
    libdrm
    libnotify
    libsecret
    libuuid
    libxml2
    libxslt
    mesa
    mesa_glu
    ncurses.dev
    netcat
    nspr
    nss
    #oraclejdk8
    pango
    pixie
    python
    nodejs-12_x
    nodePackages.node-gyp
    nodePackages.node-gyp-build
    pkgconfig
    python36Packages.cffi
    python36Packages.pip
    python36Packages.setuptools
    python36Packages.virtualenv
    python36Packages.virtualenvwrapper
    speexdsp
    strace
    SDL2
    tree
    vim
    udev
    wget
    watchexec
    which
    xdg_utils
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    unzip
    yarn
    zlib
    zsh
  ];
  multiPkgs = pkgs: with pkgs;
  [ zlib
  ];
  profile = ''
  GOPATH=/home/ben/go
  export PS1="fhs%# "
  '';
  runScript = "zsh";
}
