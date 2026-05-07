<?php
/*****EL CHAMAA mohamad****/
/*****L3 IFA 1*****/
/*28/11/2025*/

namespace App\Models;
use CodeIgniter\Model;
class Db_model extends Model
{
    protected $db;
    public function __construct()
    {
        $this->db = db_connect(); //charger la base de données
        // ou 
        // $this->db = \Config\Database::connect();
    }


    // cette fonction pour afficher les compte c.a.d afficher les pseudo 
    public function get_all_compte()
    {
        $sql = "SELECT cpt_pseudo, 
    pfl_nom, 
    pfl_prenom, 
    pfl_email, 
    pfl_numero_telephone,
     pfl_date_naissance,
      pfl_adresse, 
      vil_codePostal,
       pfl_statut, 
       cpt_etat 
       FROM t_compte_cpt  left JOIN t_profile_pfl
        USING(cpt_pseudo) 
        ORDER BY cpt_etat = 'A' DESC , cpt_etat = 'D' ASC";


        return $this->db->query($sql)->getResultArray();
    }

    public function compte_nb_total_compte()
    {
        $query = $this->db->query("SELECT COUNT(*) AS total FROM t_compte_cpt");
        return $query->getRow();

    }
    public function get_nb_comptes_actif()
{
    $sql = "SELECT COUNT(*) AS nb 
            FROM t_compte_cpt
            WHERE est_actif(cpt_pseudo) = 1";

    return $this->db->query($sql)->getRow();
}

    public function get_nb_comptes_inactif()
    {
        $resultat = $this->db->query("SELECT COUNT(*) as nb FROM t_compte_cpt where cpt_etat = 'D';");
        return $resultat->getRow();
    }
    public function set_compte($saisie)
{
    $login = esc($saisie['cpt_pseudo']);
    $mot_de_passe = esc($saisie['cpt_mdp']);

    // Salage + hashage
    $sale = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";
    $hashage = hash('sha256', $sale . $mot_de_passe);

    // Vérifier si le compte existe déjà
    $sqlCheck = "SELECT COUNT(*) AS nb 
                 FROM t_compte_cpt 
                 WHERE cpt_pseudo = ?";

    $query = $this->db->query($sqlCheck, [$login]);
    $result = $query->getRow();

    if ($result->nb == 0) {

        // Insérer le nouveau compte
        $sqlInsert = "INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mdp, cpt_etat) 
                      VALUES (?, ?, 'A')";

        return $this->db->query($sqlInsert, [$login, $hashage]);
    }

    // Le compte existe déjà
    return false;
}

    public function     verifier_un_pseudo_deja($cpt_pseudo)
    {
        $sql = "SELECT * FROM `t_compte_cpt` WHERE cpt_pseudo LIKE '" . $cpt_pseudo . "';";
        $result = $this->db->query($sql);
        return $result->getRow();
    }

    public function get_profil_info($cpt_pseudo)
    {
        $sql = "SELECT * FROM `t_profile_pfl` join t_compte_cpt using(cpt_pseudo) WHERE cpt_pseudo = '" . $cpt_pseudo . "';";
        $resultat = $this->db->query($sql);
        return $resultat->getRow();
    }


    public function connect_compte($u, $p)
    {

        $sale = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";
        $hashage = hash('sha256', $sale . $p);


        $sql = "SELECT cpt_pseudo, cpt_mdp
            FROM t_compte_cpt
            WHERE cpt_pseudo = ?
            AND cpt_mdp = ?";


        $resultat = $this->db->query($sql, [$u, $hashage]);

        if ($resultat->getNumRows() > 0) {
            return true;
        } else {
            return false;
        }
    }



    // cette fonction pour afficher les actualite mais avec un argument 
    //  dans le url c.a.d quand mets actualite/afficher_avec_parametre/(:num)
    //le num 1 donc il affiche les actualite de ce id 
    public function get_actualite($numero)
    {
        $requete = "SELECT * FROM t_actualite_act WHERE act_id=" . $numero . ";";
        $resultat = $this->db->query($requete);
        //getRow c.a.d que on affiche juste une ligne 
        return $resultat->getRow();
    }

    // ici on affiche les actualite de tous mon base de donnes dans une tableau bootstraop 
    public function affiche_acctualit_avec_tableau()
    {
        $requete = "SELECT * FROM t_actualite_act where act_etat='A' order by act_date_pub  DESC  LIMIT 5 ;";
        $resultat = $this->db->query($requete);
        return $resultat->getResultArray();
    }


    //ici cette fonction quand on mais le code de verfication il affiche les info de message 

    public function get_info_message($code)
    {
        $requet_affiche = "SELECT msg_sujet, date_de_demande, msg_contenu, msg_sender, msg_reponse
            FROM t_message_msg WHERE msg_code_verfication = ? ";
        $resultat = $this->db->query($requet_affiche, [$code]);
        return $resultat->getRow();
    }

    public function get_all_messages()
    {
        $sql = "SELECT msg_code_verfication, msg_sujet, msg_sender, date_de_demande, msg_reponse,msg_contenu FROM t_message_msg 
ORDER BY msg_reponse IS NULL DESC,date_de_demande DESC";
        return $this->db->query($sql)->getResult();
    }

    public function update_reponse($code, $reponse)
    {
        $sql = "UPDATE t_message_msg 
            SET msg_reponse = ?
            WHERE msg_code_verfication = ?";

        return $this->db->query($sql, [$reponse, $code]);
    }

    public function insertion_demande($data)
    {
        $sujet = esc($data['sujet']);
        $email = esc($data['email']);
        $question = esc($data['question']);
        $code = $data['code'];
        $requet_affiche = "INSERT INTO t_message_msg value ('" . $code . "','" . $sujet . "','" . $question . "',NULL,'" . $email . "',NULL,'NR',CURRENT_TIMESTAMP);";
        return $this->db->query($requet_affiche);
    }

    public function modifier_de_profil_admin($pseudo, $data)
    {
        // HASHAGE 
        if (!empty($data['cpt_mdp'])) {
            $salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";
            $data['cpt_mdp'] = hash('sha256', $salt . $data['cpt_mdp']);
        } else {
            // Si le mot de passe est vide 
            $ancien = $this->get_profil_info($pseudo);
            $data['cpt_mdp'] = $ancien->cpt_mdp;
        }


        $sql = "UPDATE t_profile_pfl join t_compte_cpt using(cpt_pseudo)
            SET 
                pfl_nom = ?,
                pfl_prenom = ?,
                pfl_email = ?,
                pfl_numero_telephone = ?,
                pfl_date_naissance = ?,
                pfl_adresse = ?,
                vil_codePostal = ?,
                cpt_mdp = ?
            WHERE cpt_pseudo = ?";

        return $this->db->query($sql, [
            $data['pfl_nom'],
            $data['pfl_prenom'],
            $data['pfl_email'],
            $data['pfl_numero_telephone'],
            $data['pfl_date_naissance'],
            $data['pfl_adresse'],
            $data['vil_codePostal'],
            $data['cpt_mdp'],
            $pseudo
        ]);
    }


    public function affiche_reservation($username)
    {
        $sql = "SELECT * FROM vue_reservations WHERE 
        cpt_pseudo=? ";
        return $this->db->query($sql, [$username])->getResultArray();
    }

  public function reservations_par_date($date)
{
    $sql = "SELECT * FROM vue_reservations_jour WHERE res_date = ?";

    return $this->db->query($sql, [$date])->getResultArray();
}
    public function lister_adherent_profil_compte()
    {
        $requete = "SELECT 
                pfl_nom,
                pfl_prenom,
                pfl_email,
                pfl_numero_telephone
              FROM t_profile_pfl
              JOIN t_compte_cpt USING(cpt_pseudo)  where pfl_statut='M'";

        return $this->db->query($requete)->getResultArray();
    }
    public function les_ressources (){
        $requet="SELECT * FROM t_ressource_ress ";
        return $this->db->query($requet)->getResultArray();

    }


    public function get_ressource_details_avecid($id)
{
    $sql = "CALL get_ressource(?)";
    $query = $this->db->query($sql, [$id]);

    $result = $query->getRowArray();
    return $result;
}

public function insertion_une_ressource($data)
{
    $ress_nom_jeux     = ($data['ress_nom_jeux']);
    $ress_description    = ($data['ress_description']);
    $ress_age_min  = esc($data['ress_age_min']);
    $ress_age_max  = esc($data['ress_age_max']);
    $ress_capacite_max  = esc($data['ress_capacite_max']);
    $ress_image   = esc($data['ress_image']);

    $sql = "INSERT INTO t_ressource_ress 
            VALUES (NULL,'" . $ress_nom_jeux . "','" . $ress_description . "','" . $ress_capacite_max . "',reservations_par_date NULL ,'" . $ress_age_min . "','" . $ress_age_max . "',NULL)";

    return $this->db->query($sql);
}
public function delete_ressource($id)
{
    $sql = "DELETE FROM t_ressource_ress WHERE ress_id = '" . $id . "';";
    return $this->db->query($sql);
}



}
