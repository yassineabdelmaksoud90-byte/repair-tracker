<?php

namespace Database\Seeders;

use App\Enums\EtatIntervention;
use App\Models\Client;
use App\Models\Intervention;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    // 35 clients, 58 interventions. Compte démo : GSM 20123456 / numéro 101 ou 102.
    public function run(): void
    {
        if (Client::query()->exists()) {
            $this->command?->info('Données déjà présentes : seed ignoré.');

            return;
        }

        $this->call(TechnicianSeeder::class);

        $demo = Client::factory()->create(['nom' => 'Client Démo', 'gsm' => '20123456']);
        Intervention::factory()->for($demo)->etat(EtatIntervention::EnCours)
            ->create(['numero' => '101', 'prix' => 150.000, 'date_reparation' => null]);
        Intervention::factory()->for($demo)->etat(EtatIntervention::Repare)
            ->create(['numero' => '102', 'prix' => 80.500]);

        Client::factory(34)->create()->each(function (Client $client, int $i) {
            Intervention::factory()->count($i < 22 ? 2 : 1)->for($client)->create();
        });
    }
}