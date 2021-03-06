# UTILISER VIRTUALENVWRAPPER

[VENV official documentation](https://docs.python.org/3/library/venv.html) -
[VIRTUALENVWRAPPER tutorial](https://makina-corpus.com/blog/metier/2015/bien-configurer-son-environnement-de-developpement-python)


In fact, i don't use *VENV* and *VIRTUALENV*, i directly use *VIRTUALENVWRAPPER*.

## 1 USING VENV

On **GitBash SHELL**:
```python -m venv pathname```
Launch the gitbash to the the target repertory _(programmation/python/venv/)_


## 2 VIRTUALENV AND SPECIFIC PYTHON VERSION

- create the new env with **virtualenv** package.
- next use the *-p* argument with the needed path to exec python.
```virtualenv project-py2 -p /c/Python27/python.exe```


## 3 List and install packages

> list all packages

```
pip freeze
Django==1.8.5
gunicorn==19.4.1
```

### 3.1 Save the content
```
pip freeze > requirements.txt
```

### 3.2 Install all package from requirements.txt
```
pip install -r requirements.txt
```


## 4 USING VIRTUALENVWRAPPER

### 4.1 INSTALL VIRTUALENVWRAPPER

1. Install virtualenv and virtualenvwrapper with *pip*.

2. Create ```.bash_profile``` in your user root.
then put this code inside:


```
# generated by Git for Windows
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
#
#
# - dossier contenant les environnements virtuels
export WORKON_HOME=~/.virtualenvs
mkdir -p $WORKON_HOME
# - dossier contenant les projets associés
export PROJECT_HOME=~/pyprojects
mkdir -p $PROJECT_HOME
# - s'assurer que virtualenvwrapper est toujours disponible
source  ~/AppData/Local/Programs/Python/Python36-32/Scripts/virtualenvwrapper.sh
```

>The ```virtualenvwrapper.sh``` is in the Scripts directory from your python's path folder.

### 4.2 COMMANDS

**Création d'un premier environnement:**
mkvirtualenv project1
>L'environnement est créé et automatiquement activé

Installons Django :
(project1) pip install Django==1.8

**Créons un deuxième environnement:**

(project1) mkvirtualenv project2
(project2) pip install Django==1.7
(project2) cdvirtualenv
(project2) pwd
~/.virtualenvs/project2
(project2) cdsitepackages
(project2) pwd
~/.virtualenvs/project2/lib/python2.7/site-packages

**Lister les environnements:**
(project2) lsvirtualenv -b
project1
project2

**Passer d'un environnement à l'autre:**
(project2) workon project1
(project1) workon project2
(project2)


**Supprimer un environnement:**
(project2) deactivate
rmvirtualenv project2

#### 4.2.1 Actually there is a problem

I cannot easily link a virtualenv to a project because the *setvirtualenvproject* command double the *C:\\* root in the specified pyproject path.

But there is a **good trick**; specify the path manually without the first */c/*:
 ```setvirtualenvproject ~/.virtualenvs/project3 /users/mbrio/pyprojects/project3```