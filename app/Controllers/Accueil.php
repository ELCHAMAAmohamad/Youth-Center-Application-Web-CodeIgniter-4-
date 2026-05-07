<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Accueil extends BaseController
{
    
        public function __construct()
        {
            helper('form');
            $this->model = model(Db_model::class);
        }
        // cette fonction afficher c'est pour mon template 
        // quand on met obiwan.univ...../e22301417/il affcihe mon template 
        public function afficher()
        {
            $model = model(Db_model::class);
            $data['news'] = $model->affiche_acctualit_avec_tableau();

            return view('templates/haut')
            . view('accueil/affichage_accueil',$data)
            . view('templates/bas');
        }
      
                  public function afficher_forme_contact()
        {
            return view('templates/haut')
            .view('affichage_formulaire_contact')
            . view('templates/bas');
        }
      
}
?>