<div class="container mt-5">
    <?php $session = session(); ?>
<h2>Bonjour <?= $info->pfl_nom ?> Admin</h2>
    <h3 class="text-center mb-4"> Liste des réservations</h3>

    <?php if (!empty($info_reserv)) : ?>
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Jeu / Ressource</th>
                    <th>Date</th>
                    <th>Début</th>
                    <th>Fin</th>
                    <th>Participants</th>
                </tr>
            </thead>

            <tbody>
                <?php foreach ($info_reserv as $r) { ?>
                    <tr>
                        <td><?= $r['ress_nom_jeux'] ?></td>
                        <td><?= $r['res_date'] ?></td>
                        <td><?= $r['res_heure_debut'] ?></td>
                        <td><?= $r['res_heure_fin'] ?></td>
                        <td><?= $r['participants'] ?></td>
                    </tr>
                <?php }  ?>
            </tbody>

        </table>

    <?php else : ?>

        <div class="alert alert-warning text-center">
            Aucune réservation trouvée .
        </div>

    <?php endif; ?>

</div>
