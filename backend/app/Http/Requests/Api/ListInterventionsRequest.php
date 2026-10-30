<?php

namespace App\Http\Requests\Api;

use App\Enums\EtatIntervention;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ListInterventionsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'etat' => ['nullable', Rule::enum(EtatIntervention::class)],
        ];
    }

    public function etatFilter(): ?EtatIntervention
    {
        return $this->enum('etat', EtatIntervention::class);
    }
}