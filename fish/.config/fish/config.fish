fish_add_path ~/.cargo/bin
# [a]ppend Python3.9 binaries to the end, so `pyenv` shims can take precedence.
fish_add_path -a ~/Library/Python/3.9/bin
fish_add_path -a ~/.local/bin

pyenv init - | source
direnv hook fish | source

set -gx EDITOR nvim

if status is-interactive
    starship init fish | source
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

