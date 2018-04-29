**1 Créer un nouveau dépôt**
- git init


**1.1 Créer une copie d'un dépôt local**
- git clone /path/to/repository


**2 Structure de Git**
Git est composé de 3 arbres:
- Le premier: notre *espace de travail*
- le second: un *index* qui joue le rôle de transit pour les fichiers
- le troisième: *HEAD* qui pointe vers la dernière validation.


**2.1 Proposer un changement (ajout à l'index)**
- git add <filename>
- git add *

C'est la première étape d'un workflow basique.


**2.2 Valider les changements (ajout à HEAD)**
- git commit -m "Message de validation"

Le fichier n'est pas encore ajouté au dépôt distant


**2.3 Envoyer les changements dans le dépôt distant**
- git push origin master

Si on a pas cloné un dépôt et qu'on souhaite l'ajouter à un serveur:
- git remote add origin <server>



**Bonus: pourquoi l'index?**

*source*: https://www.miximum.fr/blog/enfin-comprendre-git/

"Pourquoi trois zones, et pas seulement deux ? Quelle est donc cette mystèrieuse « staging area » ?

Qu'est-ce qu'un bon commit ?
Laissez-moi digresser quelque peu pour rappeler qu'un bon commit est un commit atomique :
- il ne concerne qu'une chose et une seule ;
- il est le plus petit possible (tout en restant cohérent).

Pourtant, lorsqu'on travaille sur une fonctionnalité, il n'est pas rare d'en profiter pour corriger une petite faute d'orthographe par ci,
un petit bug qui trénouillait par là, et on se retrouve avec un répertoire de travail contenant des modifications totalement indépendantes.

Ces modifications doivent alors faire l'objet de commits séparés, et c'est à ça que sert la zone de staging : préparer le prochain commit,
en y ajoutant ou retirant des fichiers (ou portions de fichiers) sans toucher à votre répertoire de travail.

Certains y verront sans doute un travail superflu bon à satisfaire les instincts pervers des aficionados d'attouchements intimes sur les diptères.
Il n'en est rien, et une fois qu'on y a goûté, il est tout simplement impossible de revenir en arrière."