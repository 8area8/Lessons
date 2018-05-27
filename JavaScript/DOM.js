/* eslint-disable no-console */

var h = document.head; // La variable h contient l'objet head du DOM
console.log(h);

var b = document.body; // La variable b contient l'objet body du DOM
console.log(b);


// Découvrir le type d'un noeud.
if (document.body.nodeType === document.ELEMENT_NODE) {
	console.log("Body est un noeud élément");
} else {
	console.log("Body est un noeud textuel");
}


// Accès au premier enfant du noeud body
console.log(document.body.childNodes[0]);
// les espaces entre les balises ainsi que les retours à la ligne dans le code HTML sont considérés par le navigateur
// comme des nœuds textuels. Ici, le noeudh1n'est donc que le deuxième enfant du nœudbody.


// Affiche les noeuds enfant du noeud body
for (var i = 0; i < document.body.childNodes.length; i++) {
	console.log(document.body.childNodes[i]);
}


var h1 = document.body.childNodes[1];
console.log(h1.parentNode); // Affiche le noeud body

console.log(document.parentNode); // Affiche null : document n'a aucun noeud parent




// RECUPERER DIRECTEMENT LES ELEMENTS IMPORTANTS:
// ---------------------------------------------


var titresElts = document.getElementsByTagName("h2"); // Tous les titres h2
console.log(titresElts[0]); // Affiche le premier titre h2
console.log(titresElts.length); // Affiche 3


// Tous les éléments ayant la classe "merveilles"
var merveillesElts = document.getElementsByClassName("merveilles");
for (var i = 0; i < merveillesElts.length; i++) {
	console.log(merveillesElts[i]);
}


// Elément portant l'identifiant "nouvelles"
console.log(document.getElementById("nouvelles"));




// RECHERCHES COMPLEXES (! problèmes de perfs)

// Tous les paragraphes
console.log(document.querySelectorAll("p").length); // Affiche 3

// Tous les paragraphes à l'intérieur de l'élément identifié par "contenu"
console.log(document.querySelectorAll("#contenu p").length); // Affiche 2

// Tous les éléments ayant la classe "existe"
console.log(document.querySelectorAll(".existe").length); // Affiche 8


// Tous les éléments fils de l'élément identifié par "antiques" ayant la classe "existe"
console.log(document.querySelectorAll("#antiques > .existe").length); // Affiche 1

// Le premier paragraphe
console.log(document.querySelector("p"));

/*
TABLEAU D UTILISATION DES METHODES

Nombre d'éléments à obtenir 	- Critère de sélection 				- Méthode à utiliser

Plusieurs 						- Par balise 						- getElementsByTagName
Plusieurs 						- Par classe 						- getElementsByClassName
Plusieurs 						- Autre que par balise/par classe 	- querySelectorAll
Un seul 						- Par identifiant 					- getElementById
Un seul (le premier) 			- Autre que par identifiant 		- querySelector
*/


// RECUPERER CONTENU HTML

// Le contenu HTML de l'élément identifié par "contenu"
console.log(document.getElementById("contenu").innerHTML);

// Le contenu textuel de l'élément identifié par "contenu" (sans balises html)
console.log(document.getElementById("contenu").textContent);



// L'attribut href du premier lien
console.log(document.querySelector("a").getAttribute("href"));

// L'identifiant de la première liste
console.log(document.querySelector("ul").id);

// L'attribut href du premier lien
console.log(document.querySelector("a").href);

if (document.querySelector("a").hasAttribute("target")) {
    console.log("Le premier lien possède l'attribut target");
} else {
    console.log("Le premier lien ne possède pas l'attribut target");
}


// Liste des classes de l'élément identifié par "antiques"
var classes = document.getElementById("antiques").classList;
console.log(classes.length); // Affiche 1 : l'élément possède une seule classe
console.log(classes[0]); // Affiche "merveilles"


if (document.getElementById("antiques").classList.contains("merveille")) {
    console.log("L'élément identifié par antiques possède la classe merveille");
} else {
    console.log("L'élément identifié par antiques ne possède pas la classe merveille");
}
