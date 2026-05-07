<div class="container mt-5">

    <h1 class="mb-4">Répondre à une demande de contact</h1>

    <div class="card shadow-sm">
        <div class="card-body">

            <h2 class="mb-3">Sujet : <?= $message->msg_sujet ?></h2>

            <p>
                <strong>Date de la demande :</strong>
                <?= $message->date_de_demande ?>
                <br>

                <strong>Adresse e-mail :</strong>
                <?= $message->msg_sender ?>
                <br><br>

                <strong>Question :</strong><br>
                <?= $message->msg_contenu ?>
                <br><br>
            </p>

           

           <form action="<?= base_url('index.php/message/enregistrer_reponse_message/'.$code) ?>" method="post">

                <div class="mb-4">
                    <label class="form-label">Votre réponse :</label>
                    <textarea class="form-control" rows="6" name="reponse"></textarea>
                </div>

                <?php if (session()->getFlashdata('error')): ?>
                    <div class="alert alert-danger">
                        <?= session()->getFlashdata('error') ?>
                    </div>
                <?php endif; ?>

                <button type="submit" class="btn btn-primary mt-3">Répondre</button>
            </form>


        </div>
    </div>

</div>
