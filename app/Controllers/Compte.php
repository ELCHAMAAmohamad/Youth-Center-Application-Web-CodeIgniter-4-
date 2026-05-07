<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Compte extends BaseController
{
   //  Le constructeur charge le helper 'form' et initialise le modèle Db_model
   public function __construct()
   {
      helper('form');
      $this->model = model(Db_model::class);
   }
      // -------------------------------------------------------------------------
   //  Fonction : lister()
   // Afficher la liste complète des comptes (réservé aux administrateurs)
   public function lister()
   {
      $session = session();
   // Vérifie que l’utilisateur est connecté ET est admin
    if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
   // Récupération des fonction qui sont declare dans model  et des comptes dans la base
      $data['titre'] = "Liste de tous les comptes";
      $data['comptes'] = $this->model->get_all_compte();
      $data['nb_comptes'] = $this->model->compte_nb_total_compte();
      $data['nb_cpt_actif'] = $this->model->get_nb_comptes_actif();
      $data['nb_cpt_inactif'] = $this->model->get_nb_comptes_inactif();

      return view('accueil_admin/haut_admin', $data)
         . view('connexion/affichage_compte_lister')
         . view('accueil_admin/bas_admin');
   }
   // -------------------------------------------------------------------------
   // Fonction : creer()
   // Créer un nouveau compte (formulaire + validation + insertion)
   public function creer()
   {
        $session = session();

      if (!$session->has('user') || $session->get('role') != 'A') {
         return redirect()->to(base_url('index.php/compte/connecter'));
      }
      // L’utilisateur a validé le formulaire en cliquant sur le bouton
      if ($this->request->getMethod() == "POST") {
         if (
            // Validation des champs du formulaire
            !$this->validate(
               [
                  'cpt_pseudo' => 'required|max_length[255]|min_length[2]',
                  'cpt_mdp' => 'required|max_length[255]|min_length[8]'
               ],
               [ // Configuration des messages d’erreurs
                  'cpt_pseudo' => ['required' => 'Veuillez entrer un pseudo pour le compte !',],
                  'cpt_mdp' => ['required' => 'Veuillez entrer un mot de passe !', 'min_length' => 'Le mot de passe saisi est trop court !',],
               ]
            )
         ) {
            // La validation du formulaire a échoué, retour au formulaire !
            return view('templates/haut', ['titre' => 'Créer un compte'])
               . view('compte_creer')
               . view('templates/bas');
         }
         // Récupération des données validées si tous OK 
         // La validation du formulaire a réussi, traitement du formulaire
         $recuperation = $this->validator->getValidated();
         $data['le_compte'] = $recuperation['cpt_pseudo'];
         $data['le_message'] = "Nouveau nombre de comptes : ";

         //Appel de la fonction créée dans le précédent tutoriel :
         $data['nb_comptes'] = $this->model->compte_nb_total_compte();
         // Insertion dans la base
         if ($this->model->set_compte($recuperation)) {
            return view('templates/haut', $data)
               . view('compte_succes')
               . view('templates/bas');
         } else {
            // Si le pseudo existe déjà
            return view('templates/haut', $data)
               . view('compte_exicte')
               . view('templates/bas');

         }
      }
      return view('templates/haut', ['titre' => 'Créer un compte'])
         . view('compte_creer')
         . view('templates/bas');
   }
   // -------------------------------------------------------------------------
   // Fonction : connecter()
   // Connexion de l’utilisateur + création de session + redirection selon rôle
   public function connecter()
   {
      if ($this->request->getMethod() == "POST") {
         if (
            !$this->validate(
               [
                  'pseudo' => 'required|max_length[255]|min_length[2]',
                  'mdp' => 'required|max_length[255]|min_length[8]'
               ],
               [
                  'pseudo' => ['required' => 'Identifiants erronés ou inexistants  !'],
                  'mdp' => [
                     'required' => 'Veuillez entrer un mot de passe !',
                     'min_length' => 'Le mot de passe saisi est trop court !'
                  ],
               ]
            )
         ) {
            return view('templates/haut', ['titre' => 'Se connecter'])
               . view('connexion/compte_connecter')
               . view('templates/bas');
         }

         $username = $this->request->getVar('pseudo');
         $password = $this->request->getVar('mdp');
         // Vérification des identifiants dans la base
         if ($this->model->connect_compte($username, $password)) {

            $session = session();
            $info = $this->model->get_profil_info($username);
            if(empty($info)){
                return view('accueil_member/haut_membre')
               .view('accueil_member/afficher_member_accueil')
               .view('accueil_member/bas_membre');

            }
            
            // Stockage en session
            $session->set('user', $username);
            $session->set('role', $info->pfl_statut);
            $data['info'] = $this->model->get_profil_info($username);
            $data['info_reserv'] = $this->model->affiche_reservation($username);

            if ($info->pfl_statut == 'M') {
               return view('accueil_member/haut_membre',$data)
               .view('accueil_member/afficher_member_accueil')
               .view('accueil_member/bas_membre');
            }

            if ($info->pfl_statut == 'A') {
               return view('accueil_admin/haut_admin') .
                  view('accueil_admin/affichage_admin_accueil',$data) .
                  view('accueil_admin/bas_admin');
            }
         }
         // Si identifiants invalides
         // permet d’enregistrer un message temporaire dans la session.
         session()->setFlashdata('error', 'Identifiants erronés ou inexistants !');
         return view('templates/haut', ['titre' => 'Se connecter']) .
            view('connexion/compte_connecter') .
            view('templates/bas');
      }
      return view('templates/haut', ['titre' => 'Se connecter'])
         . view('connexion/compte_connecter')
         . view('templates/bas');
   }
   // -------------------------------------------------------------------------
   // Fonction : afficher_profil()
   // Afficher le profil de l’utilisateur selon son rôle (Membre ou Admin)
   public function afficher_profil()
   {
      $session = session();
      $username = $session->get('user');

      if ($session->has('user') && $session->has('role')) {
         $data['info'] = $this->model->get_profil_info($username);

         if ($session->get('role') == 'M') {
            return view('accueil_member/haut_membre',$data)
               .view('accueil_member/compte_profil_membre')
               .view('accueil_member/bas_membre');

         } else if ($session->get('role') == 'A') {
            return view('accueil_admin/haut_admin', $data)
               . view('accueil_admin/compte_profil')
               . view('accueil_admin/bas_admin');
         }
         return view('accueil_admin/haut_admin')
            . view('connexion/compte_profil')
            . view('accueil_admin/bas_admin');
      } else
         return view('templates/haut', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');
   }
   // -------------------------------------------------------------------------
   // Fonction : admin_accueil()
   //  Page d’accueil de l’administrateur 
   public function admin_accueil()
   {
      $session = session();

      if (!$session->has('user') || $session->get('role') != 'A') {
         return redirect()->to(base_url('index.php/compte/connecter'));
      }

      $username = $session->get('user');
      $data['info'] = $this->model->get_profil_info($username);
      $data['info_reserv'] = $this->model->affiche_reservation($username);

      return view('accueil_admin/haut_admin', $data)
         . view('accueil_admin/affichage_admin_accueil')
         . view('accueil_admin/bas_admin');
   }
   // -------------------------------------------------------------------------
   // Fonction : membre_accueil()
   // Page d’accueil d’un membre
   public function membre_accueil()
   {
      $session = session();

      if (!$session->has('user') || $session->get('role') != 'M') {
         return redirect()->to(base_url('index.php/compte/connecter'));
      }

      $username = $session->get('user');
      $data['info'] = $this->model->get_profil_info($username);
      $data['info_reserv'] = $this->model->affiche_reservation($username);


      return view('accueil_member/haut_membre',$data)
               .view('accueil_member/afficher_member_accueil')
               .view('accueil_member/bas_membre');
   }
   // -------------------------------------------------------------------------
   //  Fonction : deconnecter()
   // Détruire la session et retourner au login
   public function deconnecter()
   {
      $session = session();
      $session->destroy();
      return view('templates/haut', ['titre' => 'Se connecter'])
         . view('connexion/compte_connecter')
         . view('templates/bas');
   }
   // -------------------------------------------------------------------------
   // afficher_profil_edit()
   // Rôle : Afficher le formulaire d’édition du profil (admin)
   public function afficher_profil_edit()
	{
		$session = session();
		if($session->has('user') && $session->has('role'))
		{
			$data['info'] = $this->model->get_profil_info($session->get('user'));
			return view('accueil_admin/haut_admin',$data)
					.view('accueil_admin/modifier_admin')
					.view('accueil_admin/bas_admin');
		}

	}
   // -------------------------------------------------------------------------
   // update_profil()
   // Rôle : Mettre à jour les informations du profil + validation + redirection
   public function update_profil()
   {
    $session = session();
      // Vérification du rôle (admin obligatoire)
    if (!$session->has('user') || $session->get('role') !== 'A') {
        return redirect()->to(base_url('index.php/compte/connexion'));
    }
      // Vérification des champs obligatoires
    if (
        empty($this->request->getPost('nom')) ||
        empty($this->request->getPost('prenom')) ||
        empty($this->request->getPost('email')) ||
        empty($this->request->getPost('telephone')) ||
        empty($this->request->getPost('date_naissance')) ||
        empty($this->request->getPost('adresse')) ||
        empty($this->request->getPost('code_postal'))
    ) {
        $session->setFlashdata('error', 'Champs de saisie vides !');
        return redirect()->to(base_url('index.php/compte/afficher_profil_edit'));
    }
      // Vérification de la confirmation du mot de passe
    $mdp = $this->request->getPost('mdp');
    $confirm = $this->request->getPost('confirm_mdp');

    if (!empty($mdp) && $mdp !== $confirm) {
        $session->setFlashdata('error', 'Confirmation du mot de passe erronée veuillez réessayer !');
        return redirect()->to(base_url('compte/afficher_profil_edit'));
    }
      // Préparation des données à mettre à jour
    $data = [
        'pfl_nom'              => $this->request->getPost('nom'),
        'pfl_prenom'           => $this->request->getPost('prenom'),
        'pfl_email'            => $this->request->getPost('email'),
        'pfl_numero_telephone' => $this->request->getPost('telephone'),
        'pfl_date_naissance'   => $this->request->getPost('date_naissance'),
        'pfl_adresse'          => $this->request->getPost('adresse'),
        'vil_codePostal'       => $this->request->getPost('code_postal'),
        'cpt_mdp'              => $mdp 
    ];

    $this->model->modifier_de_profil_admin($session->get('user'), $data);

    $session->setFlashdata('success', 'Profil modifié avec succès !');
    return redirect()->to(base_url('index.php/accueil_admin/admin_accueil'));
}

public function liste_adherent(){
     $session = session();
   // Vérifie que l’utilisateur est connecté ET est admin
    if (!$session->has('user') || $session->get('role') != 'M') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
    $data['titre'] = "Liste de tous les adherents";
    $data['nb_adherent'] = $this->model->lister_adherent_profil_compte();
     return view('accueil_member/haut_membre', $data)
         . view('connexion/affichage_compte_adherent')
         . view('accueil_member/bas_membre');
}
public function reservations_formulaire_date() 
{
    $session = session();

    if (!$session->has('user') || $session->get('role') != 'M') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

   return view('accueil_member/haut_membre')
         . view('accueil_member/affiche_voir_reservation')
         . view('accueil_member/bas_membre');
}

public function reservations_par_date_ajour()
{
       $session = session();

   if (!$session->has('user') || $session->get('role') != 'M') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
    $date = $this->request->getPost('date_reservation');

  

    $data['reservations'] = $this->model->reservations_par_date($date);
    $data['date'] = $date;

   return view('accueil_member/haut_membre')
         . view('accueil_member/reservations_date',$data)
         . view('accueil_member/bas_membre');
}
//tableau de ressource
public function get_ressource(){
       $session = session();

   if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
   $data['ressources'] = $this->model->les_ressources();

   return view('accueil_admin/haut_admin',$data)
					.view('accueil_admin/afficher_ressource')
					.view('accueil_admin/bas_admin');
}
public function detail_ressources ($id){
     $session = session();

   if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
   $data['ressource'] = $this->model->get_ressource_details_avecid($id);

      return view('accueil_admin/haut_admin',$data)
					.view('accueil_admin/details_ressources')
					.view('accueil_admin/bas_admin'); 
}

public function reservations_formulaire_date_admin() 
{
    $session = session();

    if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    return view('accueil_admin/haut_admin')
					.view('accueil_admin/date_formulaire_resa')
					.view('accueil_admin/bas_admin'); 
}

public function reservations_par_date_ajour_admin()
{
       $session = session();

   if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
    $date = $this->request->getPost('date_reservation');

  

    $data['reservations'] = $this->model->reservations_par_date($date);
    $data['date'] = $date;

    return view('accueil_admin/haut_admin',$data)
					.view('accueil_admin/reservation_date_admin')
					.view('accueil_admin/bas_admin'); 
}

//pour le forme 
public function ajouter_ressource_form()
{
    $session = session();

    if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }

    return view('accueil_admin/haut_admin')
         . view('accueil_admin/ajouter_ressource_form')
         . view('accueil_admin/bas_admin');
}

public function ajouter_ressource()
{
    if ($this->request->getMethod() == "POST") {
        if (
            !$this->validate(
                [
                    'ress_nom_jeux'         => 'required|max_length[255]|min_length[3]',
                    'ress_description' => 'required|max_length[500]|min_length[10]',
                    'ress_age_min'     => 'required|max_length[2]',
                    'ress_age_max'     => 'required|max_length[2]',
                    'ress_capacite_max'    => 'required|max_length[2]'
                ],
                [
                    'ress_nom_jeux' => [
                        'required' => 'Veuillez entrer un nom de ressource !'
                    ],
                    'ress_description' => [
                        'required' => 'Veuillez entrer une description valide !'
                    ],
                    'ress_age_min' => [
                        'required' => 'L\'âge minimum est obligatoire.'
                    ],
                    'ress_age_max' => [
                        'required' => 'L\'âge maximum est obligatoire.'
                    ],
                    'ress_capacite_max' => [
                        'required' => 'La capacité maximale est obligatoire.'
                    ],
                ]
            )
        ) {
            return view('accueil_admin/haut_admin')
                . view('accueil_admin/ajouter_ressource_form')
                . view('accueil_admin/bas_admin');
        }

        // si ok 
        $recup = $this->validator->getValidated();

        

         $recup['ress_image'] = "default_game.png";

        $this->model->insertion_une_ressource($recup);

        // quand on finit l'ajout alors on dit que 
        $data['message'] = "La ressource a été ajoutée avec succès !";

        return view('accueil_admin/haut_admin')
            . view('accueil_admin/ajouter_ressource_form', $data)
            . view('accueil_admin/bas_admin');
    }

    // ne pas post c.a.d 
    return view('accueil_admin/haut_admin')
        . view('accueil_admin/ajouter_ressource_form')
        . view('accueil_admin/bas_admin');
}
public function supprimer_ressource($id) {
   $session = session();

    if (!$session->has('user') || $session->get('role') != 'A') {
        return redirect()->to(base_url('index.php/compte/connecter'));
    }
    session()->setFlashdata('suprrimer', 'La ressource a été supprimée avec succès !');

    $this->model->delete_ressource($id);
        return redirect()->to(base_url('index.php/compte/get_ressource'));

}




}



