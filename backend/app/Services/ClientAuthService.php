<?php

namespace App\Services;

use App\Models\Client;
use App\Models\Intervention;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\NewAccessToken;

class ClientAuthService
{
    // Retourne l'intervention correspondant au couple (gsm, numéro), ou null.
    public function attempt(string $gsm, string $numero): ?Intervention
    {
        $client = Client::with('interventions')->where('gsm', $gsm)->first();

        if (! $client) {
            // Même travail de hachage : le temps de réponse ne révèle pas si le GSM existe.
            Hash::make($numero);

            return null;
        }

        $intervention = $client->interventions
            ->first(fn (Intervention $i) => $i->matchesNumero($numero));

        $intervention?->setRelation('client', $client);

        return $intervention;
    }

    public function issueToken(Client $client): NewAccessToken
    {
        return $client->createToken(
            'mobile',
            ['*'],
            now()->addMinutes(config('cisen.token_ttl_minutes'))
        );
    }
}