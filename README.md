# raylibnix

This repository contains NixOS packages for [raylib](https://www.raylib.com) tools:

```json
{
  "packages": {
    "x86_64-linux": {
      "rfxgen": {
        "description": "A simple and easy-to-use fx sounds generator.",
        "name": "rfxgen-7d31e9b5dff971a7d27da60c2d474f1c4be72927",
        "type": "derivation"
      },
      "rguiicons": {
        "description": "A simple and easy-to-use raygui icons editor.",
        "name": "rguiicons-8da29a1a724511069188f48d7e26b1b58e56e19b",
        "type": "derivation"
      },
      "rguilayout": {
        "description": "A simple and easy-to-use raygui layouts editor.",
        "name": "rguilayout-54f69c2515993022d35fe59f1520f11d15dd12d9",
        "type": "derivation"
      },
      "riconpacker": {
        "description": "A simple and easy-to-use icons packer and extractor.",
        "name": "riconpacker-dac689f32e7f8905a26eb666f3864331ef85bb96",
        "type": "derivation"
      }
    }
  }
}
```

These raylib tools use [tinyfiledialogs](https://sourceforge.net/projects/tinyfiledialogs/) to prompt for files/directories. I made the executive decision to use [zenity](https://help.gnome.org/users/zenity/stable/) as the default dialog implementation. You can override this to use [kdialog](https://develop.kde.org/docs/administration/kdialog/) instead: `(rguiicons.override { dialogImplementation = "kdialog"; })`

## Caveats

- I don't recommend using these packages on a Linux distribution other than NixOS. But if you insist, you'll need to use [nixGL](https://github.com/nix-community/nixGL) or an equivalent to provide the OpenGL drivers; The OpenGL drivers installed on your native Linux distribution will not be used by Nix packages.
