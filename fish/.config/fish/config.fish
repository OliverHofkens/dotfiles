alias pip3='python3 -m pip'
alias ls="lsd"

status is-interactive; and pyenv init --path | source

set PATH $HOME/.cargo/bin $PATH
direnv hook fish | source
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/ncurses/bin" $fish_user_paths
# Created by `userpath` on 2020-02-28 07:28:32
set PATH $PATH /Users/oliver/.local/bin

starship init fish | source
