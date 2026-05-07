<div class="container-fluid bg-primary px-0 px-md-5 mb-5">
    <div class="row align-items-center px-3">

        <!-- Texte -->
        <div class="col-lg-6 text-center text-lg-left">
            <h4 class="text-white mb-4 mt-5 mt-lg-0">KidsPlayRes</h4>

            <h1 class="display-3 font-weight-bold text-white">
                Réservez des activités pour vos enfants en toute simplicité
            </h1>

            <p class="text-white mb-4">
                Une plateforme moderne qui permet aux jeunes et à leurs familles
                de découvrir, planifier et réserver facilement des activités
                éducatives, sportives et culturelles. Simple, rapide et accessible
                à tous !
            </p>

            <a href="<?= base_url('index.php/accueil/afficher_forme_contact') ?>"
                class="btn btn-secondary mt-1 py-3 px-5">
                En savoir plus
            </a>
        </div>

        <!-- Image -->
        <div class="col-lg-6 text-center text-lg-right">
            <img class="img-fluid mt-5" src="<?= base_url('bootstrap/img/header.png') ?>"
                alt="KidsPlayRes illustration" />
        </div>
    </div>
</div>

<?php
echo '<table class="table table-bordered border-primary">';
echo '<thead class="thead-dark"><tr>';
echo '<th>Titre</th>';
echo '<th>Date de publication</th>';
echo '<th>Texte</th>';
echo '<th>État</th>';
echo '<th>Pseudo</th>';
echo '</tr></thead><tbody>';

if (!empty($news) && is_array($news)) {
    foreach ($news as $affiche) {
        echo '<tr>';
        echo '<td>' . $affiche['act_titre'] . '</td>';
        echo '<td>' . $affiche['act_date_pub'] . '</td>';
        echo '<td>' . $affiche['act_text'] . '</td>';
        echo '<td>' . $affiche['act_etat'] . '</td>';
        echo '<td>' . $affiche['cpt_pseudo'] . '</td>';
        echo '</tr>';
    }
} else {
    echo '<tr><td colspan="6">Aucune actualité pour linstant !.</td></tr>';
}

echo '</tbody></table>';
?>







<!-- Header End -->
<div class="container-fluid pt-5">
    <div class="container pb-3">
        <div class="row">

            <!-- Activité 1 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-050-fence h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Espace de Jeux</h4>
                        <p class="m-0">
                            Réservez facilement des activités ludiques adaptées aux jeunes : ateliers, jeux collectifs,
                            animations encadrées… Un espace fun et sécurisé.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Activité 2 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-022-drum h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Musique & Danse</h4>
                        <p class="m-0">
                            Participez à des ateliers créatifs : musique, danse, rythme, expression artistique.
                            Idéal pour développer confiance et créativité.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Activité 3 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-030-crayons h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Arts & Création</h4>
                        <p class="m-0">
                            Ateliers de dessin, peinture, modelage… Les jeunes peuvent laisser libre cours à
                            leur imagination tout en apprenant de nouvelles techniques.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Activité 4 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-017-toy-car h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Sorties & Déplacements</h4>
                        <p class="m-0">
                            Organisation simple des déplacements encadrés : activités extérieures, tournois,
                            visites éducatives et événements spéciaux.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Activité 5 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-025-sandwich h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Goûters & Nutrition</h4>
                        <p class="m-0">
                            Des collations équilibrées et adaptées aux jeunes pendant leurs activités,
                            pour un moment agréable et convivial.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Activité 6 -->
            <div class="col-lg-4 col-md-6 pb-1">
                <div class="d-flex bg-light shadow-sm border-top rounded mb-4" style="padding: 30px">
                    <i class="flaticon-047-backpack h1 font-weight-normal text-primary mb-3"></i>
                    <div class="pl-4">
                        <h4>Sorties Éducatives</h4>
                        <p class="m-0">
                            Réservez des sorties pédagogiques : musées, ateliers scientifiques, découvertes culturelles…
                            Une expérience enrichissante pour tous.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Facilities Start -->


<!-- Blog Start -->
<div class="container-fluid pt-5">
    <div class="container">
        <div class="text-center pb-2">
            <p class="section-title px-5">
                <span class="px-2">Actualités</span>
            </p>
            <h1 class="mb-4">Dernières nouveautés & activités</h1>
        </div>

        <div class="row pb-3">

            <!-- Article 1 -->
            <div class="col-lg-4 mb-4">
                <div class="card border-0 shadow-sm mb-2">
                    <img class="card-img-top mb-2" src="<?= base_url(); ?>bootstrap/img/blog-1.jpg"
                        alt="Activité sportive" />
                    <div class="card-body bg-light text-center p-4">
                        <h4>Nouvelle activité sportive pour les jeunes</h4>

                        <div class="d-flex justify-content-center mb-3">
                            <small class="mr-3"><i class="fa fa-user text-primary"></i> Admin</small>
                            <small class="mr-3"><i class="fa fa-folder text-primary"></i> Activités</small>
                            <small class="mr-3"><i class="fa fa-comments text-primary"></i> 12</small>
                        </div>

                        <p>
                            Découvrez notre nouvelle séance sportive encadrée : un mélange de jeux collectifs,
                            défis amusants et activités adaptées pour tous les âges. Réservable dès maintenant !
                        </p>

                        <a href="#" class="btn btn-primary px-4 mx-auto my-2">En savoir plus</a>
                    </div>
                </div>
            </div>

            <!-- Article 2 -->
            <div class="col-lg-4 mb-4">
                <div class="card border-0 shadow-sm mb-2">
                    <img class="card-img-top mb-2" src="<?= base_url(); ?>bootstrap/img/blog-2.jpg"
                        alt="Atelier créatif" />
                    <div class="card-body bg-light text-center p-4">
                        <h4>Atelier créatif disponible à la réservation</h4>

                        <div class="d-flex justify-content-center mb-3">
                            <small class="mr-3"><i class="fa fa-user text-primary"></i> Admin</small>
                            <small class="mr-3"><i class="fa fa-folder text-primary"></i> Création</small>
                            <small class="mr-3"><i class="fa fa-comments text-primary"></i> 8</small>
                        </div>

                        <p>
                            Peinture, découpage, collage… Un atelier 100% créativité pour permettre aux jeunes
                            de s’exprimer librement tout en apprenant de nouvelles techniques artistiques.
                        </p>

                        <a href="#" class="btn btn-primary px-4 mx-auto my-2">En savoir plus</a>
                    </div>
                </div>
            </div>

            <!-- Article 3 -->
            <div class="col-lg-4 mb-4">
                <div class="card border-0 shadow-sm mb-2">
                    <img class="card-img-top mb-2" src="<?= base_url(); ?>bootstrap/img/blog-3.jpg"
                        alt="Sortie éducative" />
                    <div class="card-body bg-light text-center p-4">
                        <h4>Sortie éducative : ouverture des inscriptions</h4>

                        <div class="d-flex justify-content-center mb-3">
                            <small class="mr-3"><i class="fa fa-user text-primary"></i> Admin</small>
                            <small class="mr-3"><i class="fa fa-folder text-primary"></i> Éducation</small>
                            <small class="mr-3"><i class="fa fa-comments text-primary"></i> 5</small>
                        </div>

                        <p>
                            Musée, atelier scientifique et découverte culturelle : une journée unique
                            pour apprendre autrement. Les places sont limitées, pensez à réserver !
                        </p>

                        <a href="#" class="btn btn-primary px-4 mx-auto my-2">En savoir plus</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Blog End -->