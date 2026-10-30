<?php

namespace Database\Factories;

use App\Models\Client;
use Illuminate\Database\Eloquent\Factories\Factory;

class ClientFactory extends Factory
{
    protected $model = Client::class;

    public function definition(): array
    {
        return [
            'nom' => fake()->name(),
            'gsm' => fake()->unique()->regexify('[259][0-9]{7}'),
        ];
    }
}