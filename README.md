# Ascribe.vim

The Vim implementation of [Ascribe][docs]: a simpler alternative to
[EditorConfig](https://editorconfig.org/).

Ascribe is a standard for software development tools (specifically editors) to
retrieve and handle useful information about various files within a project
through the `.gitattributes` file already found in many software projects.

By using the `.gitattributes` file, Ascribe keeps all information about the
files in a project in a single place.  Ascribe extensions (such as this one)
tend to be much smaller, faster and simpler than their EditorConfig
counterparts.


## Installation

Before installation it is highly recommended to **read all** of the [Ascribe
documentation][docs] (it's not very long).  The docs will teach you how to use
`.gitattributes` files and all of the default attributes handled by Ascribe.

Installation of Ascribe.vim can be performed by using your preferred
plugin/package management tool(s).  If you don’t have a Vim package manager
I recommend using Vim 8 packages.

Just run these 2 commands from your shell.

```sh
git clone https://github.com/axvr/ascribe.vim ~/.vim/pack/plugins/start/ascribe
vim +'helptags ~/.vim/pack/plugins/start/ascribe/doc/' +q
```

Once installed, be sure to check out the Ascribe.vim manual (run `:help
ascribe.txt` to open it) for information on how to configure this plugin.


## Legal

*No Rights Reserved.*

All source code, documentation and associated files packaged with Ascribe.vim
are dedicated to the public domain.  A full copy of the CC0 ([Creative Commons
Zero v1.0 Universal][cc0]) public domain dedication should have been provided
with this extension in the `COPYING` file.

The author is not aware of any patent claims which may affect the use,
modification or distribution of this software.

[docs]: https://axvr.io/projects/ascribe
[cc0]: https://creativecommons.org/publicdomain/zero/1.0/legalcode
