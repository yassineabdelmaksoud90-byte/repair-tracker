<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('interventions', function (Blueprint $table) {
            $table->id();
            $table->string('numero', 6)->unique();
            $table->string('numero_hash');
            $table->foreignId('client_id')->constrained()->cascadeOnDelete();
            $table->foreignId('technician_id')->nullable()->constrained()->nullOnDelete();
            $table->string('materiel_type');
            $table->string('materiel_marque');
            $table->string('etat', 20)->default('saisie')->index();
            $table->decimal('prix', 10, 3)->nullable();
            $table->date('date_entree');
            $table->date('date_reparation')->nullable();
            $table->timestamps();

            $table->index(['client_id', 'date_entree']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('interventions');
    }
};