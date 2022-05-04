fish_add_path ~/.cargo/bin
fish_add_path ~/Library/Python/3.9/bin

pyenv init - | source

if status is-interactive
    starship init fish | source
end
