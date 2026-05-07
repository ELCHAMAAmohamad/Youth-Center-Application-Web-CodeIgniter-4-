<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <title>Membre Dash</title>

    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="<?= base_url('bootstrap2/css/styles.css') ?>" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

    <style>
        .navbar-brand {
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .sb-sidenav .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }
    </style>
</head>

<body class="sb-nav-fixed">

    <?php $session = session(); ?>

    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">

        <a class="navbar-brand ps-3" href="<?= base_url('index.php/compte/lister') ?>">
            RESAWEB Admin
        </a>

        <button class="btn btn-link btn-sm me-4" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>

        <ul class="navbar-nav ms-auto me-3 me-lg-4">

            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button"
                    data-bs-toggle="dropdown">
                    <i class="fas fa-user-circle fa-lg"></i>
                </a>

                <ul class="dropdown-menu dropdown-menu-end">
                    <li class="dropdown-header text-center">
                    </li>

                    <li>
                        <a class="dropdown-item" href="<?= base_url('index.php/compte/afficher_profil') ?>">
                            <i class="fas fa-user"></i> Profil
                        </a>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li>
                        <a class="dropdown-item text-danger" href="<?= base_url('index.php/compte/deconnecter') ?>">
                            <i class="fas fa-sign-out-alt"></i> Déconnexion
                        </a>
                    </li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- ===== SIDEBAR ===== -->
    <div id="layoutSidenav">
        <div id="layoutSidenav_nav">

            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">

                <div class="sb-sidenav-menu">
                    <div class="nav">

                        <div class="sb-sidenav-menu-heading">Navigation</div>

                        <!-- Accueil Admin -->
                        <a class="nav-link" href="<?= base_url('index.php/compte/membre_accueil') ?>">
                            <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>
                            Accueil membre
                        </a>

                        <div class="sb-sidenav-menu-heading">Gestion</div>

                        <!-- Comptes -->
                        <a class="nav-link" href="<?= base_url('index.php/compte/liste_adherent') ?>">
                            <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                            Adherent
                        </a>

                        <!-- Messages -->
                        <a class="nav-link" href="<?= base_url('index.php/compte/reservations_formulaire_date') ?>">
                            <div class="sb-nav-link-icon"><i class="fas fa-envelope"></i></div>
                            Séances réservées
                        </a>


                       
                    </div>
                </div>



            </nav>
        </div>

        <!-- ===== OUVERTURE DU CONTENU ===== -->
        <div id="layoutSidenav_content">
            <main>