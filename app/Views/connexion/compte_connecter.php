<!-- Login Start -->
<div class="container-fluid pt-5">
    <div class="container">
        <div class="text-center pb-2">
            <p class="section-title px-5">
                <span class="px-2">Connexion</span>
            </p>
            <div class="text-danger">
                              <?= session()->getFlashdata('error') ?> 
                        </div>
        </div>
        
       

        <!-- Formulaire de connexion -->
        <?= form_open('/compte/connecter'); ?>
        <?= csrf_field() ?>

        <div class="row justify-content-center">
            <div class="col-lg-6 mb-5">
                <div class="contact-form">
                    <div id="success"></div>

                    <div class="control-group">
                        <label for="pseudo" class="font-weight-bold">Pseudo :</label>

                        <input type="input" class="form-control" id="pseudo" name="pseudo"
                            placeholder="Entrez votre pseudo" value="<?= set_value('pseudo') ?>" />

                        <div class="text-danger">
                            <?= validation_show_error('pseudo') ?>
                        </div>
                    </div>

                    <div class="control-group mt-3">
                        <label for="mdp" class="font-weight-bold">Mot de passe :</label>

                        <input type="password" class="form-control" id="mdp" name="mdp"
                            placeholder="Entrez votre mot de passe" />

                        <div class="text-danger">
                            <?= validation_show_error('mdp') ?>
                        </div>
                    </div>
                        
                    <div class="mt-4">
                        <button href="" class="btn btn-primary py-2 px-4 btn-block" type="submit" name="submit">
                            Se connecter
                        </button>
                    </div>


                </div>
            </div>
        </div>
        </form>
    </div>
</div>