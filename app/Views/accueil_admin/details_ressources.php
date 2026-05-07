<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-5 d-flex justify-content-center">

    <div class="card shadow-lg p-4" style="width: 24rem; border-radius: 15px;">

       <div class="text-center mb-3">
    <img class="rounded-circle shadow-sm" width="150px"
         src="<?= base_url('bootstrap2/assets/img/' . $ressource['ress_image']) ?>"
         alt="Photo ressource">
</div>


        <div class="card-body">

            <h4 class="card-title text-center mb-4">
                <?= $ressource['ress_nom_jeux'] ?>
            </h4>

            <p class="card-text mb-3">
                <strong>Description :</strong><br>
                <?= $ressource['ress_description'] ?>
            </p>

            <p class="card-text mb-2">
                <strong>Âge minimum :</strong> <?= $ressource['ress_age_min'] ?>
            </p>

            <p class="card-text mb-2">
                <strong>Âge maximum :</strong> <?= $ressource['ress_age_max'] ?>
            </p>

            <p class="card-text">
                <strong>Capacité maximale :</strong> <?= $ressource['ress_capacite_max'] ?>
            </p>

        </div>

    </div>

</div>
