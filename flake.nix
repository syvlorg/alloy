{
  nixConfig = {
    # Adapted From: https://github.com/divnix/digga/blob/main/examples/devos/flake.nix#L4
    accept-flake-config = true;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    cores = 0;
    extra-experimental-features =
      "nix-command flakes impure-derivations recursive-nix";
    fallback = true;
    flake-registry =
      "https://raw.githubusercontent.com/syvlorg/flake-registry/master/flake-registry.json";
    keep-derivations = true;
    keep-outputs = true;
    max-free = 1073741824;
    min-free = 262144000;
    show-trace = true;
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nickel.cachix.org-1:ABoCOGpTJbAum7U6c+04VbjvLxG9f0gJP5kYihRRdQs="
      "sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8="
    ];
    trusted-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nickel.cachix.org"
      "https://sylvorg.cachix.org"
    ];
    warn-dirty = false;
  };
  description =
    "alloy.el provides a more convenient method for binding keys in emacs (for both evil and non-evil users).";
  inputs = rec {
    bundle = {
      url = "https://github.com/sylvorg/bundle.git";
      type = "git";
      submodules = true;
    };
    valiant.follows = "bundle/valiant";
    nixpkgs.follows = "bundle/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = inputs@{ self, flake-utils, ... }:
    with builtins;
    with inputs.bundle.lib;
    with flake-utils.lib;
    inputs.bundle.mkOutputs.emacs {
      inherit inputs self;
      type = "emacs-nox";
      pname = "alloy";
      callPackage = { emacs }:
        iron.mkEmacsPackage {
          inherit self emacs;
          package = rec {
            src = ./.;
            propagatedUserEnvPkgs = toList emacs.pkgs.naked;
            meta = {
              description =
                "alloy.el provides a more convenient method for binding keys in emacs (for both evil and non-evil users).";
              long-description = ''
                This package provides convenient wrappers for more succinctly defining
                keybindings. It allows defining multiple keys at once, specifying an
                arbitrary number of named prefix keys to be used in key definitions,
                implicitly wrapping key strings with (naked ...), and more. It provides a
                single function for standard Emacs key definitions as well as aiern key
                definitions for any aiern state and any keymap. It also provides a setup
                function to generate "nmap", "vmap", etc. keybinding functions for aiern.
              '';
            };
          };
        };
    } { };
}
