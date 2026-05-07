<h2 class="text-center my-4">Gestion des ressources</h2>

<?php if (session()->getFlashdata('suprrimer')) : ?>
    <div class="alert alert-success text-center">
        <?= session()->getFlashdata('suprrimer') ?>
    </div>
<?php endif; ?>

<?php if (empty($ressources)) { ?>

    <div class="alert alert-warning text-center">
        Aucune ressource réservable pour le moment !
    </div>

<?php } else { ?>
<div class="text-end">
    <a href="<?= base_url('index.php/compte/ajouter_ressource_form') ?>" class="btn btn-primary">
        Ajouter une nouvelle ressource 
    </a>
</div>
<table class="table table-striped table-bordered">
    <thead class="table-dark">
        <tr>
            <th>Photo</th>
            <th>Nom</th>
            <th>Âge Min</th>
            <th>Âge Max</th>
            <th>Capacité Max</th>
            <th>Action</th>
        </tr>
    </thead>

    <tbody>
        <?php foreach ($ressources as $r) { ?>
        <tr>


            <td>
    <img class="rounded" width="90" height="90" 
         src="<?= base_url('bootstrap2/assets/img//' . $r['ress_image']) ?>"
alt="">         
</td>

            <td><?= $r['ress_nom_jeux'] ?></td>

            <td><?= $r['ress_age_min'] ?></td>

            <td><?= $r['ress_age_max'] ?></td>

            <td><?= $r['ress_capacite_max'] ?></td>


            <td class="text-center">

                <a href="<?= base_url('index.php/compte/detail_ressources/'. $r['ress_id']) ?>" 
                   class="btn btn-info btn-sm">
                    <i class="fas fa-eye"></i> Visualiser
                </a>

                <a href="<?= base_url('index.php/compte/supprimer_ressource/'. $r['ress_id']) ?>" 
                   class="btn btn-danger btn-sm">
                    <i class="fas fa-trash"></i> Supprimer
                </a>

            </td>

        </tr>
        <?php } ?>
    </tbody>
</table>



<?php } ?>
