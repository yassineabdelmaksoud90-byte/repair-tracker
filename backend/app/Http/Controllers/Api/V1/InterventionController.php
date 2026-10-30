<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\ListInterventionsRequest;
use App\Http\Resources\InterventionResource;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class InterventionController extends Controller
{
    // Historique du client connecté, récent d'abord. Filtre optionnel : ?etat=en_cours
    public function index(ListInterventionsRequest $request): AnonymousResourceCollection
    {
        $interventions = $request->user()
            ->interventions()
            ->etat($request->etatFilter())
            ->orderByDesc('date_entree')
            ->orderByDesc('id')
            ->get();

        return InterventionResource::collection($interventions);
    }
}