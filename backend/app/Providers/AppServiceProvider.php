<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        RateLimiter::for('login', function (Request $request) {
            $max = config('cisen.login.max_attempts');
            $decay = config('cisen.login.decay_minutes');

            $tooMany = fn (Request $request, array $headers) => response()->json([
                'message' => 'Trop de tentatives, réessayez dans quelques minutes',
            ], 429, $headers);

            return [
                // Protège un compte précis contre le brute-force du numéro.
                Limit::perMinutes($decay, $max)
                    ->by('login|'.$request->input('gsm').'|'.$request->ip())
                    ->response($tooMany),
                // Protège contre un attaquant qui change de GSM à chaque essai.
                Limit::perMinutes($decay, $max * 4)
                    ->by('login-ip|'.$request->ip())
                    ->response($tooMany),
            ];
        });
    }
}