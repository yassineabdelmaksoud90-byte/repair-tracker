# Repair Tracker

Mobile app and REST API that lets a customer follow the repair of their device
with just their phone number and intervention number.

## Features
- Login with phone number + intervention number (no account to create)
- Repair status, price and full history, filterable by status
- Token authentication (Laravel Sanctum) with expiry and logout
- Brute-force protection (rate limiting per phone + IP)

## Stack
| Layer | Technology |
|---|---|
| Mobile | Flutter / Dart |
| API | Laravel (PHP 8.3), Eloquent, Sanctum |
| Database | MySQL |
| Tests | PHPUnit (13 feature tests) |

## Architecture
Flutter app -> HTTP/JSON -> Laravel API (`/api/v1`) -> MySQL

## Getting started

### API
    cd backend
    composer install
    cp .env.example .env
    php artisan key:generate
    php artisan migrate --seed
    php artisan serve

Demo account: phone `20123456`, intervention number `101`.

### Mobile
    cd mobile
    flutter pub get
    flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1

## API
| Method | Route | Auth | Description |
|---|---|---|---|
| POST | /api/v1/login | - | Returns a bearer token |
| GET | /api/v1/interventions?etat= | Bearer | Customer history |
| POST | /api/v1/logout | Bearer | Revokes the token |

## Tests
    cd backend
    php artisan test

## Author
Yassine Abdelmaksoud, telecommunications engineering student at ENET'COM Sfax.
Built during an internship project.
