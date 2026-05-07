<?php $session = session(); ?>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container rounded bg-white mt-5 mb-5">
    <div class="row">

       
        <div class="col-md-3 border-right">
            <div class="d-flex flex-column align-items-center text-center p-3 py-5">
                <img class="rounded-circle mt-5" width="150px" 
                     src="https://i.pravatar.cc/300">

                <span class="font-weight-bold mt-3">
                    <?= $info->pfl_prenom . " " . $info->pfl_nom ?>
                </span>

                <span class="text-black-50">
                    <?= $info->pfl_email ?>
                </span>
            </div>
        </div>

 
        <div class="col-md-5 border-right">
            <div class="p-3 py-5">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="text-right">Bonjour <?= $info->pfl_nom ?> Admin</h4>
                </div>

                <div class="row mt-2">

                    <div class="col-md-6">
                        <label class="labels">Nom</label>
                        <p class="form-control bg-light"><?= $info->pfl_nom ?></p>
                    </div>

                    <div class="col-md-6">
                        <label class="labels">Prénom</label>
                        <p class="form-control bg-light"><?= $info->pfl_prenom ?></p>
                    </div>

                </div>

                <div class="row mt-3">

                    <div class="col-md-12">
                        <label class="labels">Email</label>
                        <p class="form-control bg-light"><?= $info->pfl_email ?></p>
                    </div>

                    <div class="col-md-12 mt-2">
                        <label class="labels">Téléphone</label>
                        <p class="form-control bg-light"><?= $info->pfl_numero_telephone ?></p>
                    </div>

                    <div class="col-md-12 mt-2">
                        <label class="labels">Adresse</label>
                        <p class="form-control bg-light"><?= $info->pfl_adresse ?></p>
                    </div>
                </div>

                
            </div>
                 <div class="text-end">
                        <a href="<?= base_url('index.php/compte/afficher_profil_edit') ?>" class="btn btn-primary">
                            Edit
                        </a>
                </div>

        </div>

    </div>
</div>
