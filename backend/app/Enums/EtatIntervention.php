<?php

namespace App\Enums;

enum EtatIntervention: string
{
    case Saisie = 'saisie';
    case Offre = 'offre';
    case EnCours = 'en_cours';
    case Repare = 'repare';
    case NonReparable = 'non_reparable';

    public function label(): string
    {
        return match ($this) {
            self::Saisie => 'Saisie',
            self::Offre => 'Offre envoyée',
            self::EnCours => 'En cours de réparation',
            self::Repare => 'Réparé',
            self::NonReparable => 'Non réparable',
        };
    }

    public function isFinal(): bool
    {
        return in_array($this, [self::Repare, self::NonReparable], true);
    }
}