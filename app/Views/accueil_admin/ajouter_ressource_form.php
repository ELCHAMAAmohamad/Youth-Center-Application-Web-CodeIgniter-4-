<div>
<h2 class="text-center mb-4">Ajouter une ressource</h2>

<?= form_open('compte/ajouter_ressource') ?>
        <?= csrf_field() ?>

<div class="mb-3">
    <label>Nom :</label>
    <input type="text" name="ress_nom_jeux" class="form-control" >
    <div style="color : red;"> 
                     <?= validation_show_error('ress_nom_jeux') ?>
                     </div>

</div>

<div class="mb-3">
    <label>Description :</label>
    <textarea name="ress_description" class="form-control" ></textarea>
    <div style="color : red;"> 
                     <?= validation_show_error('ress_description') ?>
</div>
</div>

<div class="mb-3">
    <label>Âge minimum :</label>
    <input type="number" name="ress_age_min" class="form-control" >
    <div style="color : red;"> 
                         <?= validation_show_error('ress_age_min') ?>
</div>
    
</div>

<div class="mb-3">
    <label>Âge maximum :</label>
    <input type="number" name="ress_age_max" class="form-control" >
    <div style="color : red;"> 
                         <?= validation_show_error('ress_age_max') ?>
</div>
</div>

<div class="mb-3">
    <label>Capacité maximale :</label>
    <input type="number" name="ress_capacite_max" class="form-control" >
    <div style="color : red;"> 
                         <?= validation_show_error('ress_capacite_max') ?>
                         </div>

</div>



<button type="submit" class="btn btn-success">Ajouter</button>
<?php if (!empty($message)) { ?>
    <div class="alert alert-success">
<?php echo $message; ?>
    </div>
<?php }; ?>

</form>
</div>