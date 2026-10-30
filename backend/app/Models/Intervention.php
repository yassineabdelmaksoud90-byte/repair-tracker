<?php

namespace App\Models;

use App\Enums\EtatIntervention;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Hash;

class Intervention extends Model
{
    use HasFactory;

    protected $fillable = [
        'client_id', 'technician_id', 'numero',
        'materiel_type', 'materiel_marque',
        'etat', 'prix', 'date_entree', 'date_reparation',
    ];

    protected $hidden = ['numero_hash'];

    protected function casts(): array
    {
        return [
            'etat' => EtatIntervention::class,
            'prix' => 'decimal:3',
            'date_entree' => 'date',
            'date_reparation' => 'date',
        ];
    }

    // Affecter "numero" calcule automatiquement "numero_hash" (bcrypt).
    protected function numero(): Attribute
    {
        return Attribute::set(fn (string $value) => [
            'numero' => $value,
            'numero_hash' => Hash::make($value),
        ]);
    }

    public function matchesNumero(string $numero): bool
    {
        return Hash::check($numero, $this->numero_hash);
    }

    public function scopeEtat(Builder $query, ?EtatIntervention $etat): Builder
    {
        return $etat ? $query->where('etat', $etat->value) : $query;
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    public function technician(): BelongsTo
    {
        return $this->belongsTo(Technician::class);
    }
}