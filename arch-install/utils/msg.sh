#!/usr/bin/env bash
MSG_GREEN='\033[0;32m'
MSG_RED='\033[0;31m'
MSG_END='\033[0m'

msg(){
    printf "\n${MSG_GREEN}${1}\n${MSG_END}"
}
error_msg(){
    printf "\n${MSG_RED}${1}\n${MSG_END}"
}
