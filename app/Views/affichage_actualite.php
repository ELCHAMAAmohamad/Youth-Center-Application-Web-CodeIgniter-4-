<h1><?php echo $titre;?></h1><br />
        <?php
        if (isset($news)){
        echo $news->act_id;
        echo(" -- ");
        echo $news->act_titre;
        ?>
        <br>
        <?php
        echo $news->act_date_pub;

        }
        else {
        echo ("Pas d'actualité !");
        }
?>
