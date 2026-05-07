<section class="container-fluid pt-2">
  <div class="container">
    <div class="text-center pb-2">
      <p class="section-title px-5"><span class="px-2">Contact</span></p>
      <h1 class="mb-4">Contactez-nous</h1>
    </div>

    <div class="row">
      
      <!-- Formulaire Contact -->
      <div class="col-lg-7 mb-5">
        <div class="contact-form">
        <?= session()->getFlashdata('error') ?>

        <?php echo form_open('message/envoyer'); ?>
        <?= csrf_field() ?>

          <div class="mb-3">
              <label class="form-label">Sujet</label>
              <input type="text" class="form-control" name="sujet" >
              <div style="color : red;"> 
                 <?= validation_show_error('sujet') ?>
              </div>
          </div>

          <div class="mb-3">
              <label class="form-label">E-mail</label>
              <input type="email" class="form-control" name="email" >
              <div style="color : red;"> 
                 <?= validation_show_error('email') ?>
              </div>
          </div>

          <div class="mb-4">
              <label class="form-label">Question</label>
              <textarea class="form-control" rows="6" name="question" ></textarea>
              <div style="color : red;"> 
                 <?= validation_show_error('question') ?>
              </div>
          </div>

          <button class="btn btn-primary py-2 px-4" type="submit">
              Envoyer
          </button>
      </form>

        </div>
      </div>

      <!-- Infos Contact -->
      <div class="col-lg-5 mb-5">

        <p class="mb-4">
          Vous pouvez également nous joindre via les coordonnées suivantes.
        </p>

        <div class="d-flex mb-3">
          <i class="fa fa-map-marker-alt bg-primary text-secondary rounded-circle d-flex align-items-center justify-content-center"
            style="width:45px;height:45px;"></i>
          <div class="pl-3">
            <h5>Adresse</h5>
            <p class="m-0">123 Rue Exemple, 29200 Brest</p>
          </div>
        </div>

        <div class="d-flex mb-3">
          <i class="fa fa-envelope bg-primary text-secondary rounded-circle d-flex align-items-center justify-content-center"
            style="width:45px;height:45px;"></i>
          <div class="pl-3">
            <h5>Email</h5>
            <p class="m-0">contact@kidsplayres.fr</p>
          </div>
        </div>

        <div class="d-flex mb-3">
          <i class="fa fa-phone-alt bg-primary text-secondary rounded-circle d-flex align-items-center justify-content-center"
            style="width:45px;height:45px;"></i>
          <div class="pl-3">
            <h5>Téléphone</h5>
            <p class="m-0">+33 2 98 00 00 00</p>
          </div>
        </div>



      </div>
    </div>
  </div>
<section class="container-fluid pt-5">
  <div class="container">
    <div class="text-center pb-3">
      <h1 class="mb-3">Suivi de demande</h1>

      <p class="text-muted m-0">
        Saisissez votre <strong>code à 20 caractères</strong>
      </p>
    </div>

    <!-- Flashdata erreur -->
    <?= session()->getFlashdata('error'); ?>

    <!-- Formulaire -->
    <?= form_open('/message/afficher_message_formulaire'); ?>
    <?= csrf_field() ?>
<input type="text" name="code" class="form-control center">
      <div style="color : red;"> 
                 <?= validation_show_error('code') ?>
              </div>


    
    <br>

    <button type="submit" class="btn btn-primary px-4">Suivre</button>

    </form>

  </div>
</section>
