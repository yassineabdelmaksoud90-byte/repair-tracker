<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'gsm' => ['required', 'string', 'regex:/^\d{8}$/'],
            'numero' => ['required', 'string', 'regex:/^\d{3,6}$/'],
        ];
    }

    public function messages(): array
    {
        return [
            'gsm.regex' => 'Le GSM doit contenir exactement 8 chiffres.',
            'numero.regex' => "Le numéro d'intervention doit contenir de 3 à 6 chiffres.",
        ];
    }
}