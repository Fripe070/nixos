Fripe's personal NixOS configs.
Not meant to be used by anyone else, but might prove useful as reference.

## Using... if you really want to
Copy `identity.nix.example` to `identity.nix` and fill out the fields.

Assuming the repo is cloned into `nixos`, build and switch the system with ```
# nixos-rebuild switch --flake path:nixos#laptop
```
