<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Resources\ClientResource;
use App\Http\Resources\InterventionResource;
use App\Services\ClientAuthService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AuthController extends Controller
{
    public function login(LoginRequest $request, ClientAuthService $auth): JsonResponse
    {
        $intervention = $auth->attempt(
            $request->validated('gsm'),
            $request->validated('numero'),
        );

        if (! $intervention) {
            return response()->json(['message' => 'Identifiants incorrects'], 401);
        }

        $client = $intervention->client;
        $token = $auth->issueToken($client);

        return response()->json([
            'data' => [
                'token' => $token->plainTextToken,
                'token_type' => 'Bearer',
                'expires_at' => $token->accessToken->expires_at?->toIso8601String(),
                'client' => (new ClientResource($client))->resolve(),
                'intervention' => (new InterventionResource($intervention))->resolve(),
            ],
        ]);
    }

    public function logout(Request $request): Response
    {
        $request->user()->currentAccessToken()->delete();

        return response()->noContent();
    }
}