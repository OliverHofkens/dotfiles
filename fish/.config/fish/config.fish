set PATH $HOME/.cargo/bin $PATH

alias pip3='python3 -m pip'
alias ls="lsd"

thefuck --alias | source
status --is-interactive; and source (pyenv init -|psub)

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
set PATH $HOME/.cargo/bin $PATH
direnv hook fish | source
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/oliver/repos/nove-0037-barry-web/node_modules/tabtab/.completions/slss.fish ]; and . /Users/oliver/repos/nove-0037-barry-web/node_modules/tabtab/.completions/slss.fish
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/ncurses/bin" $fish_user_paths

# Created by `userpath` on 2020-02-28 07:28:32
set PATH $PATH /Users/oliver/.local/bin

starship init fish | source
