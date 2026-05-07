<div class="container-fluid pt-5">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-8 mb-5">
        <div class="card shadow-sm border-0">
          <div class="card-body text-center">

            <h2 class="mb-4">Bravo !</h2>

            <p class="lead">
              Le compte <strong><?php echo($le_compte) ?></strong> a été ajouté avec succès.
            </p>

            <p class="mb-3">
              <?php echo($le_message) ?>
              <strong><?php echo ($nb_comptes->total) ?></strong>
            </p>

            <a href="<?php echo base_url('index.php/compte/creer');?>" class="btn btn-primary mt-3">
              retour au formulaire
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
