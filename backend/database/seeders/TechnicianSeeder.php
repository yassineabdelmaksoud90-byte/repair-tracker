<?php

namespace Database\Seeders;

use App\Models\Technician;
use Illuminate\Database\Seeder;

class TechnicianSeeder extends Seeder
{
    public function run(): void
    {
        foreach (['Riadh', 'Imed', 'Khalil'] as $nom) {
            Technician::firstOrCreate(['nom' => $nom]);
        }
    }
}