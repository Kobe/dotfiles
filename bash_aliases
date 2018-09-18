alias brewUpgrade='brew update && brew upgrade && brew cask upgrade && brew cleanup'
alias browserlist='npx browserslist'
alias dockerList='docker ps -a'
alias dockerRemove='docker ps -a -q | xargs docker rm -f'
alias listen8080='lsof -i :8080 | grep LISTEN'
alias ll='ls -la'
alias mcp='mvn clean package'
alias mcv='mvn clean verify'
alias msbr='mvn spring-boot:run'
alias msbrd='mvn docker:start spring-boot:run'
alias mni='mvn frontend:npm'
alias myi='mvn frontend:yarn'
alias npm_global='npm list -g --depth=0'
alias simpleHttpServer='python -m SimpleHTTPServer 8080'
