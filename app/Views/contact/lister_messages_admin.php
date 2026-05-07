    <?php $session = session(); ?>

<div class="container mt-4">

    <h2>Liste des messages</h2>

    <table class="table table-bordered mt-3">
        <thead>
            <tr>
                <th>Sujet</th>
                <th>Email</th>
                <th>Date</th>
                <th>Question</th>
                <th>Statut</th>
                <th>Action</th>
            </tr>
        </thead>

        <tbody>
        <?php foreach ($messages as $m): ?>
            <tr>
                <td><?= $m->msg_sujet ?></td>
                <td><?= $m->msg_sender ?></td>
                <td><?= $m->date_de_demande ?></td>
                <td><?= $m->msg_contenu ?></td>


                <td>
                    <?php if ($m->msg_reponse == null) { ?>
                        <span class="badge bg-danger">Non répondu</span>
                    <?php } else { ?>
                        <span class="badge bg-success">Répondu</span>
                    <?php } ?>
                </td>

                <td>
                    <a href="<?= base_url('index.php/message/repondre_message/'.$m->msg_code_verfication) ?>" 
                       class="btn btn-primary btn-sm">
                        Répondre
                    </a>
                </td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>

</div>
