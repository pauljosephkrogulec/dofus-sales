# Dofus Craft Manager

Application web de gestion de craft Dofus (Bûcheron, Paysan, Alchimiste,
Mineur, Pêcheur), qui remplace un ancien outil Excel.

- Suivi des niveaux de métier
- Prix des ressources, ingrédients et objets craftés
- Calcul automatique du coût de fabrication, de la marge et du % de bénéfice
- Classement « Top rentabilité »
- Conseil « acheter ou crafter » pour chaque ingrédient
- Accès protégé par login (un seul utilisateur)

## Stack

| Partie   | Technologies                                                                        |
|----------|-------------------------------------------------------------------------------------|
| Backend  | PHP 8.4, Symfony 7.4 LTS, API Platform 5, Doctrine ORM 3, PostgreSQL 18, JWT        |
| Frontend | React 19, TypeScript 7, Vite 8, TanStack Query 5, React Router 8, Tailwind 4        |
| Infra    | Docker Compose (php-fpm, nginx 1.30, postgres, node 24 LTS)                         |
| Tests    | PHPUnit 13, Vitest 5 + React Testing Library                                        |

## Structure

```
backend/       Symfony + API Platform (API REST / JSON-LD)
frontend/      React + Vite (SPA)
KANBAN.md      Suivi des tâches par sprint
```

## Démarrage

Prérequis : Docker avec Docker Compose.

```bash
docker compose up -d --build
```

| Service    | Rôle                              | Accès                   |
|------------|-----------------------------------|-------------------------|
| `database` | PostgreSQL 18                     | interne (port 5432)     |
| `backend`  | PHP 8.4 FPM + Composer (Symfony)  | via nginx               |
| `nginx`    | Serveur web de l'API              | http://localhost:8080   |
| `frontend` | Node 24, serveur de dev Vite      | http://localhost:5173   |

Les identifiants Postgres valent `app` par défaut ; ils se surchargent avec
les variables `POSTGRES_DB`, `POSTGRES_USER` et `POSTGRES_PASSWORD` (fichier
`.env` à la racine, ignoré par git).

> 🚧 Sprint 0 en cours : Doctrine (#5) et la CI (#6) restent à faire.

## Suivi du projet

Le projet avance par sprints (0 à 6). Les tâches sont suivies dans les
[issues GitHub](https://github.com/pauljosephkrogulec/dofus-sales/issues) et
dans [`KANBAN.md`](KANBAN.md).
