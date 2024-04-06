## download Node.js
    https://nodejs.org/ko/
#### node version check
    node -v
#### npm version check
    npm -v


## install react
    npx create-react-app ${project_name}

## How to Build
    npm run build

# Sever setting
## install nvm
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm --version
    nvm ls-remote -lts
    nvm install 
    node --version
    
## make server
    npm install -g serve

## run build 
    npx serve -s build -l ${port} > react.log 2>&1 &
