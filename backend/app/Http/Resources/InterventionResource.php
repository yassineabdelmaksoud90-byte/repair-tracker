<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class InterventionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'numero' => $this->numero,
            'etat' => $this->etat->value,
            'etat_label' => $this->etat->label(),
            'prix' => $this->prix !== null ? (float) $this->prix : null,
            'materiel_type' => $this->materiel_type,
            'materiel_marque' => $this->materiel_marque,
            'date_entree' => $this->date_entree?->toDateString(),
            'date_reparation' => $this->date_reparation?->toDateString(),
        ];
    }
}