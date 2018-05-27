/*eslint-disable no-console */


// Modification du contenu HTML de la liste : ajout d'un langage
document.getElementById("langages").innerHTML += "<li id='c'>C</li>";

// Suppression du contenu HTML de la liste
document.getElementById("langages").innerHTML = "";

// Modification du contenu textuel du premier titre
document.querySelector("h1").textContent += " de programmation";



// Définition de l'attribut "id" du premier titre
document.querySelector("h1").setAttribute("id", "titre");
// équivalent au code ci-dessus:
document.querySelector("h1").id = "titre";

var titreElt = document.querySelector("h1"); // Accès au premier titre h1
titreElt.classList.remove("debut"); // Suppression de la classe "debut"
titreElt.classList.add("titre"); // Ajout de la classe "titre"
console.log(titreElt);




// AJOUTER UN ELEMENT
// ------------------


var pythonElt = document.createElement("li"); // Création d'un élément li
pythonElt.id = "python"; // Définition de son identifiant
pythonElt.textContent = "Python"; // Définition de son contenu textuel
document.getElementById("langages").appendChild(pythonElt); // Insertion du nouvel élément

var rubyElt = document.createElement("li"); // Création d'un élément li
rubyElt.id = "ruby"; // Définition de son identifiant
rubyElt.appendChild(document.createTextNode("Ruby")); // Définition de son contenu textuel
document.getElementById("langages").appendChild(rubyElt); // Insertion du nouvel élément



// AJOUT D'UN ELEMENT ET CHOISIR SA PLACE DANS UN NOEUD:

var perlElt = document.createElement("li"); // Création d'un élément li
perlElt.id = "perl"; // Définition de son identifiant
perlElt.textContent = "Perl"; // Définition de son contenu textuel
// Ajout du nouvel élément avant l'identifiant identifié par "php"
document.getElementById("langages").insertBefore(perlElt, document.getElementById("php"));


// Ajout d'un élément au tout début de la liste (très puissant)
/*
beforebegin	: avant l'élément existant lui-même.
afterBegin	: juste à l'intérieur de l'élément existant, avant son premier enfant.
beforeend	: juste à l'intérieur de l'élément existant, après son dernier enfant.
afterend	: après l'élément existant lui-même.
*/
document.getElementById("langages").insertAdjacentHTML("afterBegin",
	"<li id='javascript'>JavaScript</li>");



// REMPLACER OU SUPPRIMER UN NOEUD


var bashElt = document.createElement("li"); // Création d'un élément li
bashElt.id = "bash"; // Définition de son identifiant
bashElt.textContent = "Bash"; // Définition de son contenu textuel
// Remplacement de l'élément identifié par "perl" par le nouvel élément
document.getElementById("langages").replaceChild(bashElt, document.getElementById("perl"));


// Suppression de l'élément identifié par "bash"
document.getElementById("langages").removeChild(document.getElementById("bash"));