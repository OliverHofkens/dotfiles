fish_add_path ~/.cargo/bin
fish_add_path -a ~/.local/bin

direnv hook fish | source

set -gx EDITOR nvim

if status is-interactive
    starship init fish | source
end

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
