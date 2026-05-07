<div class="container-fluid px-4">

    <h1 class="mt-4"><?php echo $titre; ?></h1>

    <div class="row">

        <div class="col-xl-3 col-md-6">
            <div class="card bg-primary text-white mb-4">
                <h4 class="mb-0">COMPTES</h4>

                <?php if (!empty($nb_comptes)) { ?>
                    <div class="card-body"><?php echo $nb_comptes->total; ?></div>
                <?php } ?>

            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card bg-warning text-white mb-4">
                <h4 class="mb-0">COMPTES ACTIFS</h4>

                <?php if (!empty($nb_cpt_actif)) { ?>
                    <div class="card-body"><?php echo $nb_cpt_actif->nb; ?></div>
                <?php } ?>

            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card bg-success text-white mb-4">
                <h4 class="mb-0">COMPTES INACTIFS</h4>

                <?php if (!empty($nb_cpt_inactif)) { ?>
                    <div class="card-body"><?php echo $nb_cpt_inactif->nb; ?></div>
                <?php } ?>

            </div>
        </div>

    </div>
    <div class="d-flex justify-content-end mb-3">
        <a href="<?= base_url('index.php/compte/creer') ?>" class="btn btn-success">
            <i class="bi bi-person-plus"></i> Ajouter un compte invité
        </a>
    </div>


    <div class="card mb-4">

        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Liste de tous les comptes
        </div>

        <div class="card-body">
            <table id="datatablesSimple">

                <thead>
                    <tr>
                        <th>Pseudo</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>Date Naissance</th>
                        <th>Adresse</th>
                        <th>Code Postal</th>
                        <th>Status</th>
                        <th>Etat</th>
                        <th>Action</th>



                    </tr>
                </thead>

                <tbody>
                    <?php
                    if (!empty($comptes)) {
                        foreach ($comptes as $pseudos) {
                            echo "<tr>";

                            echo "<td>{$pseudos['cpt_pseudo']}</td>";
                            echo "<td>{$pseudos['pfl_nom']}</td>";
                            echo "<td>{$pseudos['pfl_prenom']}</td>";
                            echo "<td>{$pseudos['pfl_email']}</td>";
                            echo "<td>{$pseudos['pfl_numero_telephone']}</td>";
                            echo "<td>{$pseudos['pfl_date_naissance']}</td>";
                            echo "<td>{$pseudos['pfl_adresse']}</td>";
                            echo "<td>{$pseudos['vil_codePostal']}</td>";
                            echo "<td>{$pseudos['pfl_statut']}</td>";
                            ;

                            echo "<td>";
                            if ($pseudos["cpt_etat"] === 'A') {
                                echo '<span class="badge bg-success">ACTIF</span>';
                            } else {
                                echo '<span class="badge bg-secondary">INACTIF</span>';
                            }
                            echo "</td>";
                            echo "<td class='d-flex gap-2'>";

                            echo '<button class="btn btn-primary btn-sm" disabled>
        <i class="bi bi-eye"></i> Voir
      </button>';

                            echo '<button class="btn btn-warning btn-sm" disabled>
        <i class="bi bi-pencil-square"></i> Modifier
      </button>';

                            echo '<button class="btn btn-secondary btn-sm" disabled>
        <i class="bi bi-person-x"></i> Désactiver
      </button>';

                            echo '<button class="btn btn-danger btn-sm" disabled>
        <i class="bi bi-trash"></i> Supprimer
      </button>';

                            echo "</td>";


                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='10'><h3>Aucun compte/profil pour le moment !</h3></td></tr>";
                    }
                    ?>
                </tbody>

            </table>
            <!-- //desacitiver la buuton maintant  -->
            <div class="d-flex justify-content-end mb-3">
                <button class="btn btn-success" disabled>
                    <i class="bi bi-person-plus"></i> Ajouter un compte / profil
                </button>
            </div>

        </div>


    </div>

</div>

</main>
</div>

</div>