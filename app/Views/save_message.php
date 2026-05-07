<div class="container mt-5">

    <div class="card shadow-lg border-0" style="border-radius: 15px;">
        <div class="card-body text-center p-5">

            <div class="mb-4">
                <i class="fas fa-check-circle" style="font-size: 60px; color: #28a745;"></i>
            </div>

            <h2 class="mb-3" style="color:#155724; font-weight:700;">
                Votre message a été envoyé !
            </h2>

            <p class="lead mb-4" style="color:#444;">
                Merci pour votre demande, nous vous répondrons rapidement.
            </p>

            <div class="alert alert-info mx-auto" style="max-width: 450px; font-size: 18px;">
                <strong>Votre code de suivi :</strong><br>
                <span style="font-size:24px; font-weight:bold; letter-spacing:2px;">
                    <?= esc($code) ?>
                </span>
            </div>

            <a href="<?= base_url('index.php/accueil/afficher_forme_contact') ?>"
               class="btn btn-primary px-4 py-2 mt-3">
                Retour à l'accueil
            </a>

        </div>
    </div>

</div>
