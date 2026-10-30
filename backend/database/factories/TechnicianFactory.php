<?php

namespace Database\Factories;

use App\Models\Technician;
use Illuminate\Database\Eloquent\Factories\Factory;

class TechnicianFactory extends Factory
{
    protected $model = Technician::class;

    public function definition(): array
    {
        return ['nom' => fake()->firstName()];
    }
}