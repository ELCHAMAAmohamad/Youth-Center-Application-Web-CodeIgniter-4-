<?php
namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Message extends BaseController
{

    public function __construct()
    {
        helper('form');
        $this->model = model(Db_model::class);
    }

    public function afficher_message($chaine = null)
    //ici j'ai fais les "" pour que ca marche le utl quand j'enleve le segment
    {
        if ($chaine === null || $chaine === "") {
            $data['info'] = "vide";
            return view('templates/haut')
                . view('suivi_message', $data)
                . view('templates/bas');
        }

        $data['titre'] = "Suivi de votre demande";
        $data['info'] = $this->model->get_info_message($chaine);

        return view('templates/haut')
            . view('suivi_message', $data)
            . view('templates/bas');
    }



    public function afficher_message_formulaire()
    {
        if ($this->request->getMethod() == "POST") {
            if (
                !$this->validate(
                    [
                        'code' => 'required|min_length[20]|max_length[255]',
                    ],
                    [
                        'code' => [
                            'required' => 'Merci de saisir un code valide composé de 20 caractères!',
                            'min_length' => 'Le code doit comporter 20 caractères!',
                        ]
                    ]
                )
            ) {
                return view('templates/haut')
                    . view('affichage_formulaire_contact')
                    . view('templates/bas');
            }

            // Récupération
            $recuperation = $this->validator->getValidated();
            $code = $recuperation['code'];

            // Récupérer informations
            $data['info'] = $this->model->get_info_message($code);

            return view('templates/haut', $data)
                . view('suivi_message')
                . view('templates/bas');
        }
    }


    function generateCode20()
    {
        return bin2hex(random_bytes(10));
    }


    public function envoyer()
    {
        if ($this->request->getMethod() == "POST") {

            if (
                !$this->validate(
                    [
                        'sujet' => 'required|max_length[255]|min_length[8]',
                        'email' => 'required|max_length[255]|min_length[8]',
                        'question' => 'required|max_length[255]|min_length[8]'
                    ],
                    [
                        'sujet' => [
                            'required' => 'Veuillez entrer un sujet valide !',
                            'min_length' => 'Le sujet doit contenir au moins 8 caractères.',
                            'max_length' => 'Le sujet ne doit pas dépasser 255 caractères.'
                        ],
                        'email' => [
                            'required' => 'Veuillez entrer un email valide !',
                            'min_length' => 'L’email doit contenir au moins 8 caractères.',
                            'max_length' => 'L’email ne doit pas dépasser 255 caractères.'
                        ],
                        'question' => [
                            'required' => 'Veuillez entrer une question valide !',
                            'min_length' => 'La question doit contenir au moins 8 caractères.',
                            'max_length' => 'La question ne doit pas dépasser 255 caractères.'
                        ]
                    ]
                )
            ) {
                return view('templates/haut', ['titre' => 'Contact'])
                    . view('affichage_formulaire_contact')
                    . view('templates/bas');
            }

            // Validation OK
            $recuperation = $this->validator->getValidated();

            // Génération du code
            $code_20 = $this->generateCode20();
            $recuperation['code'] = $code_20;

            // Insertion DB
            $this->model->insertion_demande($recuperation);
            $data['code'] = $code_20;

            return view('templates/haut')
                . view('save_message', $data)
                . view('templates/bas');
        }

        return view('templates/haut')
            . view('affichage_formulaire_contact')
            . view('templates/bas');
    }

    public function contact()
    {
        $session = session();

        // Sécurité : vérifier admin
        if (!$session->has('user') || $session->get('role') != 'A') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }


        // Récupérer tous les messages
        $data['messages'] = $this->model->get_all_messages();

        return view('accueil_admin/haut_admin')
            . view('contact/lister_messages_admin', $data)
            . view('accueil_admin/bas_admin');
    }

    public function repondre_message($code = null)
    {
        $session = session();

        if (!$session->has('user') || $session->get('role') != 'A') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        $message = $this->model->get_info_message($code);

        if ($message === null) {
            session()->setFlashdata('error', 'Message introuvable');
            return redirect()->to(base_url('index.php/message/contact'));
        }

        $data['message'] = $message;
        $data['code'] = $code;

        return view('accueil_admin/haut_admin')
            . view('contact/contact_repondre', $data)
            . view('accueil_admin/bas_admin');
    }

    public function enregistrer_reponse_message($code)
    {
        if ($this->request->getMethod() == "POST") {

            $reponse = $this->request->getPost('reponse');

            if (empty($reponse)) {
                session()->setFlashdata('error', 'Veuillez remplir le formulaire !');
                return redirect()->to(base_url('index.php/message/repondre_message/' . $code));
            }

            $this->model->update_reponse($code, $reponse);

            session()->setFlashdata('success', 'Réponse enregistrée avec succès !');
            return redirect()->to(base_url('index.php/message/contact'));
        }
    }


}
