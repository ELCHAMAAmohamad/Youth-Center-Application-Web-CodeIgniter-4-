 <?php $session = session(); ?>
<div class="container my-5">
    <div class="card shadow-sm border-0 rounded-4">
        <div class="card-body p-4">

            <h4 class="fw-bold mb-4"><i class="bi bi-person-gear"></i> Modifier le profil</h4>
 <?= form_open('/compte/update_profil'); ?>
        <?= csrf_field() ?>

                <hr class="my-4">

                <h5 class="fw-bold mb-3"><i class="bi bi-person-vcard"></i> Informations personnelles</h5>

            
                <div class="mb-3">
                    <label class="form-label">Nom</label>
                    <input type="text" class="form-control" name="nom"
                           value="<?= $info->pfl_nom ?>">
                </div>

               
                <div class="mb-3">
                    <label class="form-label">Prénom</label>
                    <input type="text" class="form-control" name="prenom"
                           value="<?= $info->pfl_prenom ?>">
                </div>

                
                <div class="mb-3">
                    <label class="form-label">E-mail</label>
                    <input type="email" class="form-control" name="email"
                           value="<?= $info->pfl_email ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">N° Téléphone</label>
                    <input type="text" class="form-control" name="telephone"
                           value="<?= $info->pfl_numero_telephone ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Date de naissance</label>
                    <input type="date" class="form-control" name="date_naissance"
                           value="<?= $info->pfl_date_naissance ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Adresse</label>
                    <input type="text" class="form-control" name="adresse"
                           value="<?= $info->pfl_adresse ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Code postal</label>
                    <input type="text" class="form-control" name="code_postal"
                           value="<?= $info->vil_codePostal ?>">
                </div>

                <hr class="my-4">

                <h5 class="fw-bold mb-3"><i class="bi bi-lock"></i> Sécurité</h5>

                <div class="mb-3">
                    <label class="form-label">Nouveau mot de passe</label>
                    <input type="password" class="form-control" name="mdp"
                           placeholder="Laisser vide si vous ne changez pas le mot de passe">
                </div>

                <div class="mb-4">
                    <label class="form-label">Confirmation du mot de passe</label>
                    <input type="password" class="form-control" name="confirm_mdp"
                           placeholder="Confirmez le mot de passe">
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a  href="<?= base_url('index.php/accueil_admin/admin_accueil') ?>" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Annuler
                    </a>

                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Enregistrer les modifications
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>
