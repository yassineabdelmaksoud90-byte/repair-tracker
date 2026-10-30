<?php

namespace Database\Factories;

use App\Enums\EtatIntervention;
use App\Models\Client;
use App\Models\Intervention;
use App\Models\Technician;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\Factory;

class InterventionFactory extends Factory
{
    protected $model = Intervention::class;

    public function definition(): array
    {
        $etat = fake()->randomElement(EtatIntervention::cases());
        $entree = Carbon::instance(fake()->dateTimeBetween('-90 days', '-10 days'));

        return [
            'client_id' => Client::factory(),
            'technician_id' => fn () => Technician::query()->inRandomOrder()->value('id'),
            'numero' => (string) fake()->unique()->numberBetween(1000, 999999),
            'materiel_type' => fake()->randomElement([
                'Ordinateur portable', 'PC de bureau', 'Imprimante', 'Smartphone', 'Écran',
            ]),
            'materiel_marque' => fake()->randomElement([
                'HP', 'Dell', 'Lenovo', 'Asus', 'Acer', 'Samsung', 'Canon', 'Epson',
            ]),
            'etat' => $etat,
            'prix' => $etat === EtatIntervention::Saisie ? null : fake()->randomFloat(3, 20, 800),
            'date_entree' => $entree,
            'date_reparation' => $etat->isFinal()
                ? $entree->copy()->addDays(fake()->numberBetween(1, 8))
                : null,
        ];
    }

    public function etat(EtatIntervention $etat): static
    {
        return $this->state(function (array $attributes) use ($etat) {
            $entree = Carbon::parse($attributes['date_entree']);

            return [
                'etat' => $etat,
                'prix' => $etat === EtatIntervention::Saisie
                    ? null
                    : ($attributes['prix'] ?? fake()->randomFloat(3, 20, 800)),
                'date_reparation' => $etat->isFinal()
                    ? ($attributes['date_reparation'] ?? $entree->copy()->addDays(3))
                    : null,
            ];
        });
    }
}