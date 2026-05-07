<?php
// les 2 lignes ci-
// dessous qui ajoutent une route vers le controller Accueil et sa fonction membre
// afficher() :

use App\Controllers\Accueil;
use App\Controllers\Compte;
use App\Controllers\Actualite;
use App\Controllers\Message;





/* routes pour le controlleur Accueil */
$routes->get('/', 'Accueil::afficher');
$routes->get('accueil/afficher', [Accueil::class, 'afficher']);
$routes->get('accueil/afficher_forme_contact', [Accueil::class, 'afficher_forme_contact']);

/* routes pour le controlleur Accueil_admin */
// $routes->get('accueil_admin/afficher_admin', [Accueil_admin::class, 'afficher_admin']);

/* routes pour le controlleur Compte */
$routes->get('compte/lister', [Compte::class, 'lister']);
// $routes->get('compte/compte_nb_total_compte', [Compte::class, 'lister']);

// formulaire de ctréation de compte invité.e
$routes->get('compte/creer', [Compte::class, 'creer']); 
$routes->post('compte/creer', [Compte::class, 'creer']);

/* routes pour le controlleur Actualite */
$routes->get('actualite/afficher', [Actualite::class, 'afficher']);
$routes->get('actualite/afficher_avec_parametre/(:num)', [Actualite::class, 'afficher']);

/* routes pour le controlleur Contact */
$routes->get('message/afficher_message/(:segment)', [Message::class, 'afficher_message']);
$routes->get('message/afficher_message', [Message::class, 'afficher_message']);

$routes->get('message/afficher_message_formulaire', [Message::class, 'afficher_message_formulaire']);
$routes->post('message/afficher_message_formulaire', [Message::class, 'afficher_message_formulaire']);

$routes->get('message/envoyer', [Message::class, 'envoyer']);
$routes->post('message/envoyer', [Message::class, 'envoyer']);



$routes->get('compte/connecter', [Compte::class, 'connecter']); 
$routes->post('compte/connecter', [Compte::class, 'connecter']);

$routes->get('compte/afficher_profil', [Compte::class, 'afficher_profil']);

$routes->get('compte/deconnecter', [Compte::class, 'deconnecter']);

$routes->get('compte/admin_accueil', [Compte::class, 'admin_accueil']);



$routes->get('compte/afficher_profil_edit', [Compte::class, 'afficher_profil_edit']);
$routes->post('compte/update_profil', [Compte::class, 'update_profil']);


$routes->get('message/contact', [Message::class, 'contact']);
$routes->get('message/repondre_message/(:segment)',[Message::class,'repondre_message']);
$routes->post('message/enregistrer_reponse_message/(:segment)', [Message::class,'enregistrer_reponse_message']);


$routes->get('compte/membre_accueil', [Compte::class, 'membre_accueil']);
$routes->get('compte/liste_adherent', [Compte::class, 'liste_adherent']);

$routes->get('compte/reservations_formulaire_date', [Compte::class, 'reservations_formulaire_date']);
$routes->post('compte/reservations_par_date_ajour', [Compte::class,'reservations_par_date_ajour']);

$routes->get('compte/reservations_formulaire_date_admin', [Compte::class, 'reservations_formulaire_date_admin']);
$routes->post('compte/reservations_par_date_ajour_admin', [Compte::class,'reservations_par_date_ajour_admin']);

$routes->get('compte/get_ressource', [Compte::class, 'get_ressource']);


$routes->get('compte/detail_ressources/(:segment)', [Compte::class, 'detail_ressources']);


$routes->get('compte/ajouter_ressource_form', [Compte::class, 'ajouter_ressource_form']);

$routes->post('compte/ajouter_ressource', [Compte::class, 'ajouter_ressource']);

$routes->get('compte/supprimer_ressource/(:segment)', [Compte::class, 'supprimer_ressource']);



