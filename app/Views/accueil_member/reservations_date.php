<?php
if ($reservations != NULL) {
    ?>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Ressource</th>
                <th>Réservations</th>
            </tr>
        </thead>

        <tbody>

            <?php
            $traite = [];

            foreach ($reservations as $r) {

                if (!isset($traite[$r["ress_nom_jeux"]])) {

                    $ressource = $r["ress_nom_jeux"];

                    echo "<tr>";
                    echo "<td>" . $ressource . "</td>";
                    echo "<td>";

                    foreach ($reservations as $res) {

                        if ($res["ress_nom_jeux"] == $ressource) {

                            echo "<ul>";
                            echo "<li>";

                            echo "<b>Date :</b> " . $res["res_date"] . "<br>";
                            echo "<b>Début :</b> " . $res["res_heure_debut"] .
                                " | <b>Fin :</b> " . $res["res_heure_fin"] . "<br>";

                        echo "<b>Responsable :</b> " .$res["responsable"] ."<br>";
                            echo "<b>Participants :</b> " . $res["participants"];

                            echo "</li>";
                            echo "</ul>";
                        }

                    }

                    echo "</td>";

                    // Marquer cette ressource comme traitée
                    $traite[$ressource] = 1;

                    echo "</tr>";
                }
            }

} else {
    echo "<br />Aucune réservation pour cette date !";
}
?>

    </tbody>
</table>