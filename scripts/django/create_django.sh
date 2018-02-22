#!/bin/bash
# This simple script creates a new Django project configured in a nice
# way.

show(){
    GREEN='\033[0;32m'
    END='\033[0m'
    
    printf "\n${GREEN}${1}\n${END}"
}

show "Creating suitable django project for Heroku..."
django-admin startproject --template="https://github.com/heroku/\
heroku-django-template/archive/master.zip" --name=Procfile  $1
cd $1
chmod a+x manage.py
rm .gitignore README.md > /dev/null 2>&1

show "Setting up venv and pip packages..."
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

show "Migrating database..."
python manage.py migrate

show "Setting up git..."
git init

if (( $# == 2 ))
then
    git remote add origin $2
	wget https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore -O .gitignore
	git add -A
	git commit -m "Add Django template project"
	git pull --no-edit origin master
    git push origin master
fi
