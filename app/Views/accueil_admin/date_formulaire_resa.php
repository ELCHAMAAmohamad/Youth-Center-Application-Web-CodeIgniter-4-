<h3 class="text-center mb-4">Sélectionnez une date</h3>
     <?= form_open('/compte/reservations_par_date_ajour_admin'); ?>
        <?= csrf_field() ?>
        <div class="mb-3 w-50 mx-auto">
            <input type="date" name="date_reservation" class="form-control" required>
        </div>

        <div class="text-center">
            <button class="btn btn-primary" type="submit">Voir les réservations</button>
        </div>
    </form>