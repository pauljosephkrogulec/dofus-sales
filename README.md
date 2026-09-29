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

| Partie   | Technologies                                                        |
|----------|---------------------------------------------------------------------|
| Backend  | PHP 8.3, Symfony 7, API Platform, Doctrine ORM, PostgreSQL 16, JWT  |
| Frontend | React 18, TypeScript, Vite, TanStack Query, React Router, Tailwind  |
| Infra    | Docker Compose (php-fpm, nginx, postgres, node)                     |
| Tests    | PHPUnit, Vitest + React Testing Library                             |

## Structure

```
backend/       Symfony + API Platform (API REST / JSON-LD)
frontend/      React + Vite (SPA)
KANBAN.md      Suivi des tâches par sprint
```

## Démarrage

> 🚧 En cours de mise en place (Sprint 0). Les instructions d'installation
> et de lancement (`docker compose up`) seront ajoutées au fil des sprints.

## Suivi du projet

Le projet avance par sprints (0 à 6). Les tâches sont suivies dans les
[issues GitHub](https://github.com/pauljosephkrogulec/dofus-sales/issues) et
dans [`KANBAN.md`](KANBAN.md).
