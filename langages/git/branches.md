# LES BRANCHES

Une branche est une étiquette qui pointe vers un commit.

C'est un simple fichier qui ne contient rien d'autre que l'identifiant (un hash SHA1) d'un commit.
Dans le jargon Git, cette notion de nom référençant un commit s'appelle une « référence ».
*Un autre exemple de référence nous est donné par les tags.*

La référence HEAD pointe vers le commit qui sera le parent du prochain commit (soit la plupart du temps, une branche).
La branche **master** est la branche principale du projet. Chaque projet possède sa branche **master**.

## Manipuler les branches

*git branch* permet de créer, lister et supprimer des branches.
*git checkout* permet de déplacer la référence HEAD, notamment vers une nouvelle branche.

- **git checkout -b nom_de_la_branche**: équivalent des deux commandes ci dessus.

## Fusionner les branches

*git checkout master*  # On se place sur la branche qui va "recevoir" les modifications de l'autre branche
*git merge test*  # FuuuuuuuuuuuuSion !
*git branch -d test*  # Une fois fusionnée, notre branche ne sert plus, et peut être supprimée

CONFLITS DE FUSION:

à finir.
source:
https://www.miximum.fr/blog/enfin-comprendre-git/