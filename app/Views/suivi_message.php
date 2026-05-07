<div class="container mt-5">

    <?php if (empty($info)) { ?>
        <div class="card shadow-sm border-danger mb-4">
            <div class="card-body text-center">
                <h3 class="text-danger">Le code que vous avez saisi ne correspond à aucune demande enregistrée</h3>
                <a href="<?= base_url('index.php/accueil/afficher_forme_contact') ?>" 
                   class="btn btn-primary mt-3">
                    Retour au formulaire
                </a>
            </div>
        </div>
  

    <?php } 
        else if ($info === "vide"){?>
            <div class="card shadow-sm border-danger mb-4">
            <div class="card-body text-center">
                <h3 class="text-danger"> VIDE </h3>
                <a href="<?= base_url('index.php/accueil/afficher_forme_contact') ?>"
                   class="btn btn-primary mt-3">
                    Retour au formulaire
                </a>
            </div>
        </div>

       <?php }
    else { ?>

        <h1 class="mb-4">RESAWEB</h1>

        <div class="card shadow-sm">
            <div class="card-body">

                <h2 class="mb-3"><?= $info->msg_sujet ?></h2>

                <p>
                    <strong>Date de la demande :</strong>
                    <?= $info->date_de_demande ?>
                    <br>

                    <strong>Adresse e-mail :</strong>
                    <?= $info->msg_sender ?>
                    <br><br>

                    <strong>Question :</strong><br>
                    <?= $info->msg_contenu ?>
                    <br><br>

                    <?php if ($info->msg_reponse == null || $info->msg_reponse == "") { ?>
                        <p style="color:red;">L'administrateur n'a pas encore traité votre question !</p>
                    <?php } else { ?>
                        <h6 class="card-text" style="color:black;">Réponse : <?= $info->msg_reponse ?></h6>
                    <?php } ?>
                </p>

            </div>
        </div>

    <?php } ?>

</div>
