<nav class="navbar navbar-expand-lg bg-light navbar-light py-3 py-lg-0 px-0 px-lg-5">
  <a href="<?= base_url(); ?>" class="navbar-brand font-weight-bold text-secondary" style="font-size: 50px">
    <i class="flaticon-043-teddy-bear"></i>
    <span class="text-primary">KidsPlayRes</span>
  </a>

  <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">

    <div class="navbar-nav font-weight-bold mx-auto py-0">
      <a href="<?= base_url(); ?>" class="nav-item nav-link active">Accueil</a>

  

      <a href="<?= base_url(); ?>index.php/accueil/afficher_forme_contact" class="nav-item nav-link">
        Contact
      </a>
    </div>

    <a href="<?= base_url(); ?>index.php/compte/connecter" class="btn btn-primary px-4">Connexion</a>
  </div>
</nav>
