#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'

export PROJ_BASE="$(dirname "${BASH_SOURCE[0]}")"
CD=$(pwd)
cd $PROJ_BASE
export PROJ_BASE=$(pwd)
export THEME_FOLDER="$PROJ_BASE"/wp-content/themes/fictional-university/
cd $CD

export PROJ_UID=`id -u`
export PROJ_GID=`id -g`

. helpers/git_aliases.sh

function devhelp {
    echo -e "${GREEN}devhelp${RESTORE}                              Prints this ${RED}help${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dkup_dev${RESTORE}                             [DEV]Builds and starts docker containers${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dk <command>${RESTORE}                         It runs the command inside php docker in the default workdir(/var/www/html)"
    echo -e "                                     Example:"
    echo -e "                                       dk ${RED}bash${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dkbuild${RESTORE}                             [DEV]Builds docker containers${RESTORE}"
    echo -e ""
    echo -e "${GREEN}docker_prune${RESTORE}                         Prunes volumes, dangling images and some other docker resources"
    echo -e ""
    echo -e "${GREEN}hm${RESTORE}                         Goes to home project folder"
    echo -e ""
    echo -e "${GREEN}tm${RESTORE}                         Goes to theme folder"
    echo -e ""
    echo -e "${GREEN}gw${RESTORE}                         Starts dev watcher"
    echo -e ""
}


function dkbuild {
    CD=$(pwd)
    cd $PROJ_BASE
    docker-compose -f docker-compose-base.yml -f docker-compose-dev.yml build $@
    exitcode=$?
    cd $CD
    return $exitcode
}

function dkup_dev {
    CD=$(pwd)
    cd $PROJ_BASE
    docker-compose -f docker-compose-base.yml -f docker-compose-dev.yml up --force-recreate --build --remove-orphans $@
    exitcode=$?
    cd $CD
    return $exitcode
}


function docker_prune {
    docker system prune -f
    docker volume prune -f
    docker images -q --filter "dangling=true" | xargs -r docker rmi
}

function echo_red {
     echo -e "${RED}$1${RESTORE}";
}

function echo_green {
     echo -e "${GREEN}$1${RESTORE}";
}

function echo_yellow {
    echo -e "${YELLOW}$1${RESTORE}";
}

function dk {
    CD=$(pwd)
    cd $PROJ_BASE
    docker exec -it fu_web $@
    exitcode=$?
    cd $CD
    return $exitcode
}

function dkng {
    CD=$(pwd)
    cd $PROJ_BASE
    docker exec -it fu_nginx $@
    exitcode=$?
    cd $CD
    return $exitcode
}

function tm {
    cd $THEME_FOLDER
}

function hm {
    cd $PROJ_BASE
}

function gw {
    CD=$(pwd)
    tm
    npx gulp build
    npm run gulpwatch
    cd $CD
    return $exitcode
}

nvm install

_create_git_aliases

echo_green "Welcome to Fictional Univesity's dev env"
echo_green "Hint: autocomplete works for the commands below ;)"
echo_red   "------------------------------------------------------------------------"
devhelp
