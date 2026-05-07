<div class="container-fluid px-4">

<br>
<br>
    <div class="row">

        <div class="col-xl-3 col-md-6">
            
        </div>
        <div class="card mb-4">

            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Liste de tous les Adherent
            </div>

            <div class="card-body">
                <table id="datatablesSimple">

                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>


                        </tr>
                    </thead>

                    <tbody>
                        <?php
                        if (!empty($nb_adherent)) {
                            foreach ($nb_adherent as $adherent) {
                                echo "<tr>";

                                echo "<td>{$adherent['pfl_nom']}</td>";
                                echo "<td>{$adherent['pfl_prenom']}</td>";
                                echo "<td>{$adherent['pfl_email']}</td>";
                                echo "<td>{$adherent['pfl_numero_telephone']}</td>";

                            }
                        } else {
                            echo "<tr><td colspan='10'><h3>Aucun adhérent pour le moment ! !</h3></td></tr>";
                        }
                        ?>
                    </tbody>

                </table>


            </div>


        </div>

    </div>

    </main>
</div>

</div>