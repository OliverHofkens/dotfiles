alias vim="/Applications/MacVim.app/Contents/bin/mvim -v"
alias vagrant="cd ~/saki; and vagrant"
alias dkr-redis="docker run -d -p 6379:6379 redis"
alias dkr-mysql="docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin  mysql:latest"
alias dkr-dynamo="docker run -d -p 8000:8000 deangiberson/aws-dynamodb-local"
alias pip3='python3 -m pip'
alias mpd='mpd ~/.config/mpd/mpd.conf'


thefuck --alias | source
status --is-interactive; and source (pyenv init -|psub)

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish