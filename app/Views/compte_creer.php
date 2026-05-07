<!-- Login Start -->
<div class="container-fluid pt-5">
  <div class="container">
    <div class="text-center pb-2">
      <p class="section-title px-5">
        <span class="px-2">Créer votre compte</span>
      </p>
      <h1 class="mb-4"><?php echo ($titre) ?></h1>
    </div>
    <!-- session()->getFlashdata('error') → affiche un éventuel message d’erreur global (par exemple erreur serveur, problème technique). -->
    <!-- validation_list_errors() → affiche toutes les erreurs de validation (champs vides, longueur minimale pas respectée, etc.) sous forme de liste. -->
    <?= session()->getFlashdata('error') ?>
    <?= validation_list_errors() ?>
    <!-- Formulaire qui pointe vers /compte/creer (routes GET + POST déjà définies) -->
    <?php echo form_open('/compte/creer'); ?>
    <?= csrf_field() ?>
    <div class="row justify-content-center">
      <div class="col-lg-6 mb-5">
        <div class="contact-form">
          <div id="success"></div>
          <!-- Formulaire de création de compte -->
          <div class="control-group">
            <label for="cpt_pseudo" class="font-weight-bold">Pseudo</label>
            <input type="text" class="form-control" id="cpt_pseudo" name="cpt_pseudo"
              placeholder="Entrez votre pseudo" />
            <div style="color : red;">
              <?= validation_show_error('cpt_pseudo') ?>
            </div>
            <p class="help-block text-danger">
            </p>
          </div>
          <div class="control-group mt-3">
            <label for="cpt_mdp" class="font-weight-bold">Mot de passe</label>
            <input type="password" class="form-control" id="cpt_mdp" name="cpt_mdp"
              placeholder="Entrez votre mot de passe" autocomplete="new-password" />
            <div style="color : red;">
              <?= validation_show_error('cpt_mdp') ?>
            </div>
            <p class="help-block text-danger">
            </p>
          </div>
          <div class="mt-4">
            <button class="btn btn-primary py-2 px-4 btn-block" type="submit" name="submit">
              Créer un nouveau compte
            </button>
               <a href="<?php echo base_url('index.php/compte/lister');?>" class="btn btn-primary mt-3">
              retour 
            </a>
          </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>