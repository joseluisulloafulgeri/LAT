#! /bin/bash

# definition d'une fonction avec un argument
function coucou {
name=$1
echo "dans function coucou: $name"
}

# appel de la fonction avec un argument local
prenom="Nathalie"
coucou ${prenom}

# appel de la fonction avec un argument passé au script
prenom2=$1
coucou ${prenom2}

# boucle de 1 à 10 (i=1, i=2, ..., i=10)
for i in {1..10}
do
    echo ${i}
done

# boucle i=tata, i=toto, i=titi
for i in tata toto titi
do
    echo ${i}
done

# boucle sur des fichiers
for i in `ls`
do
    echo ${i}
done

# boucle sur des fichiers
for i in `ls *script`
do
    echo ${i}
done
