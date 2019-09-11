/*eslint-disable no-console*/

// Exécute un appel AJAX GET
// Prend en paramètres l'URL cible et la fonction callback appelée en cas de succès
function ajaxGet(url, callback) {
	var req = new XMLHttpRequest();
	req.open("GET", url);
	req.addEventListener("load", function () {
		if (req.status >= 200 && req.status < 400) {
			// Appelle la fonction callback en lui passant la réponse de la requête
			callback(req.responseText);
		} else {
			console.error(req.status + " " + req.statusText + " " + url);
		}
	});
	req.addEventListener("error", function () {
		console.error("Erreur réseau avec l'URL " + url);
	});
	req.send(null);
}




// JSON MES AMIS!
// --------------


var avion = {
	marque: "Airbus",
	couleur: "A320"
};
console.log(avion);
// Transforme l'objet JavaScript en chaîne de caractères JSON
var texteAvion = JSON.stringify(avion);
console.log(texteAvion);
// Transforme la chaîne de caractères JSON en objet JavaScript
console.log(JSON.parse(texteAvion));


var avions = [
	{
		marque: "Airbus",
		couleur: "A320"
	},
	{
		marque: "Airbus",
		couleur: "A380"
	}
];
console.log(avions);
// Transforme le tableau d'objets JS en chaîne de caractères JSON
var texteAvions = JSON.stringify(avions);
console.log(texteAvions);
// Transforme la chaîne de caractères JSON en tableaux d'objets JavaScript
console.log(JSON.parse(texteAvions));




// requête HTTP AJAX pour récupérer un contenu JSON. La classe.
ajaxGet("http://localhost/javascript-web-srv/data/films.json", function (reponse) {
	// Transforme la réponse en tableau d'objets JavaScript
	var films = JSON.parse(reponse);
	// Affiche le titre de chaque film
	films.forEach(function (film) {
		console.log(film.titre);
	});
});



// Exécute un appel AJAX POST
// Prend en paramètres l'URL cible, la donnée à envoyer et la fonction callback appelée en cas de succès
// Le paramètre isJson permet d'indiquer si l'envoi concerne des données JSON
function ajaxPost(url, data, callback, isJson) {
	var req = new XMLHttpRequest();
	req.open("POST", url);
	req.addEventListener("load", function () {
		if (req.status >= 200 && req.status < 400) {
			// Appelle la fonction callback en lui passant la réponse de la requête
			callback(req.responseText);
		} else {
			console.error(req.status + " " + req.statusText + " " + url);
		}
	});
	req.addEventListener("error", function () {
		console.error("Erreur réseau avec l'URL " + url);
	});
	if (isJson) {
		// Définit le contenu de la requête comme étant du JSON
		req.setRequestHeader("Content-Type", "application/json");
		// Transforme la donnée du format JSON vers le format texte avant l'envoi
		data = JSON.stringify(data);
	}
	req.send(data);
}




// RECUPERE TOUTES LES DONNES D UN FORMULAIRE ET LES ENVOIT AU SERVEUR.

var form = document.querySelector("form");
// Gestion de la soumission du formulaire
form.addEventListener("submit", function (e) {
	e.preventDefault();
	// Récupération des champs du formulaire dans l'objet FormData
	var data = new FormData(form);
	// Envoi des données du formulaire au serveur
	// La fonction callback est ici vide
	ajaxPost("http://localhost/javascript-web-srv/post_form.php", data, function () {});
});
