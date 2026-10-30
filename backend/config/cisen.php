<?php

return [

    // Durée de vie (minutes) d'un token d'accès mobile.
    'token_ttl_minutes' => (int) env('CISEN_TOKEN_TTL', 120),

    // Anti-force-brute sur POST /api/v1/login (par GSM + IP).
    'login' => [
        'max_attempts' => (int) env('CISEN_LOGIN_MAX_ATTEMPTS', 5),
        'decay_minutes' => (int) env('CISEN_LOGIN_DECAY_MINUTES', 5),
    ],

];