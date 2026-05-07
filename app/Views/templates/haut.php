
<!DOCTYPE html>
<html lang="en">
  <head>
    <!--
   Auteur  : ELCHAMAA mohamad (e22301417)
    Projet  : KidsplayRes / ResaWeb – Application de réservation d’activités (13–20 ans)
    Détails : Front public basé sur le template KidKinder • CodeIgniter 4 + Bootstrap
              BDD MySQL/MariaDB • Architecture MVC • Hébergé sur obiwan.univ-brest.fr (Debian 12 / Apache)
              Version : V1 • Date : 10/11/2025
    -->
    <meta charset="utf-8" />
    <title>KidKinder - Kindergarten Website Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="Free HTML Templates" name="keywords" />
    <meta content="Free HTML Templates" name="description" />

    <!-- Favicon -->
    <link href="<?php echo base_url();?>bootstrap/img/favicon.ico" rel="icon" />
z
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com" />
    <link
      href="https://fonts.googleapis.com/css2?family=Handlee&family=Nunito&display=swap"
      rel="stylesheet"
    />

    <!-- Font Awesome -->
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
      rel="stylesheet"
    />

    <!-- Flaticon Font -->
    <link href="<?php echo base_url();?>bootstrap/lib/flaticon/font/flaticon.css" rel="stylesheet" />

    <!-- Libraries Stylesheet -->
    <link href="<?php echo base_url();?>bootstrap/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
    <link href="<?php echo base_url();?>bootstrap/lib/lightbox/css/lightbox.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="<?php echo base_url();?>bootstrap/css/style.css" rel="stylesheet" />
  </head>

  <body>
    <!-- Navbar Start -->
    <div class="container-fluid bg-light position-relative shadow">
      <?php echo view('templates/menu_visiteur');?>
    </div>
    <!-- Navbar End -->
