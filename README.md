# Neovim configuration

In order for this config to work, a number of CLI tools and language servers
should be installed.

## Tools

On Arch install with:

```bash
sudo pacman -S fzf fd git gdb lldb make zoxide
```

On Debian-based systems:

```bash
sudo pacman -Syu git gdb lldb make
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
git clone --depth 1 https://github.com/junegunn/fzf.git && ./install
cargo install fd-find
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

Set up is required for `zoxide` and `fzf` which may or may not be automatic, for
example `zoxide init fish | source` in `~/.config/fish/config.fish`

## Language servers

```bash
# C++: clang
sudo pacman -S clang
# Rust: rust_analyzer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# HTML: html
npm install --save vscode-html-languageservice
# Typescript: ts_ls
npm install -g typescript-language-server typescript
# JSON: vscode-json-languageservice
npm install --save vscode-json-languageservice

# CSS: cssls
# TODO WHICH WORKS?
npm install -g vscode-langservers-extracted
# OR INSTEAD
npm install --save vscode-css-languageservice

# Fish: fish_lsp
npm install -g fish-lsp
# Bash: bashls
sudo pacman -S bash-language-server shfmt
# XML: lemminx
wget 'https://github.com/redhat-developer/vscode-xml/releases/download/0.29.0/lemminx-linux.zip' && unzip lemminx-linux.zip && mv lemminx-linux ~/.local/bin/lemminx
# Python: pylsp
sudo pacman -S python-lsp-server autopep8
# TOML: taplo
cargo install --features lsp --locked taplo-cli
```
