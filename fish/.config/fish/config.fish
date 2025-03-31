eval "$(/opt/homebrew/bin/brew shellenv)"
fish_add_path ~/.cargo/bin
fish_add_path -a ~/.local/bin

direnv hook fish | source

set -gx EDITOR nvim

if status is-interactive
    starship init fish | source
end
