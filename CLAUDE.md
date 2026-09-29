# CLAUDE.md — Dofus Craft Manager

Ce fichier donne à Claude Code le contexte du projet avant toute intervention.
Lis-le entièrement avant de coder quoi que ce soit.

## Qu'est-ce que ce projet

Application web qui remplace un ancien outil Excel de gestion de craft Dofus
(métiers Bûcheron, Paysan, Alchimiste, Mineur, Pêcheur). Elle permet de :
- suivre mes niveaux de métier
- renseigner les prix des ressources et des objets craftés
- calculer automatiquement coût de fabrication, prix de vente, marge, % de
  bénéfice
- afficher un classement "Top rentabilité"
- indiquer pour chaque ingrédient s'il vaut mieux l'ACHETER ou le CRAFTER
  soi-même (comparaison de coût)
- verrouiller l'accès au site derrière un login/mot de passe (un seul
  utilisateur, pas d'inscription publique)

## Stack technique (ne pas dévier sans demander)

- Backend : PHP 8.3, Symfony 7, **API Platform**, Doctrine ORM, PostgreSQL 16
- Auth : JWT via LexikJWTAuthenticationBundle
- Frontend : React 18 + TypeScript + Vite, TanStack Query, React Router,
  TailwindCSS
- Infra : Docker Compose (php-fpm, nginx, postgres, node)
- Tests : PHPUnit (backend), Vitest/React Testing Library (frontend)

## Structure du dépô
/backend -> Symfony + API Platform (API REST/JSON-LD)
/frontend -> React + Vite (SPA)
docker-compose.yml
KANBAN.md -> suivi des tâches (voir section Workflow ci-dessous)

## Modèle de données (résumé — voir les entités pour le détail exact)

- `Metier` : Bûcheron, Paysan, Alchimiste, Mineur, Pêcheur
- `NiveauJoueur` : niveau (1-200) d'un utilisateur pour un métier
- `Ressource` : matière première RÉELLEMENT récoltable par un des 5 métiers
  (bois, céréales, minerais, poissons/algues, plantes) + prix d'achat
- `AutreIngredient` : ingrédient de recette non récoltable (drop de monstre,
  achat divers — ex Blé d'Or, Minerai Étrange) + prix d'achat
- `ItemCrafte` : objet fabricable + prix de vente
- `Recette` : produit un ItemCrafte, appartient à un Métier, a un niveau
  requis et une catégorie (Planches, Substrats, Pains, Potions de vie, etc.)
- `RecetteIngredient` : jusqu'à 8 lignes par recette, quantité + référence
  polymorphe vers Ressource OU AutreIngredient OU ItemCrafte (un ingrédient
  peut être un objet intermédiaire que je crafte moi-même, ex une Planche
  utilisée dans un Substrat)

**Règle importante de classement des données** : un objet n'entre dans
`Ressource` QUE s'il est vraiment récolté par un des 5 métiers. Tout ce qui
vient d'un monstre (drop) ou s'achète sans être récolté va dans
`AutreIngredient`, jamais dans `Ressource`. Ne pas mélanger les deux, même si
ça simplifierait le modèle.

## Règles métier (logique à ne jamais dupliquer côté front — tout se calcule côté API)

1. **Coût de fabrication** = somme de `quantité × prix_unitaire_effectif`
   pour chaque ingrédient de la recette.
2. **prix_unitaire_effectif(ingrédient)** :
   - Ressource / AutreIngredient simple → son prix d'achat.
   - ItemCrafte qui a sa propre Recette → `MIN(prix de vente, coût de
     fabrication de SA recette calculé récursivement)`. On compare acheter
     vs crafter et on garde le moins cher. Protéger la récursion contre les
     cycles (il ne devrait pas y en avoir dans les données, mais mettre une
     limite de profondeur par sécurité).
   - Exposer aussi un flag `moins_cher_a_crafter: bool` par ingrédient pour
     l'affichage front (badge violet si true).
3. **Marge** = prix de vente − coût de fabrication.
4. **% Bénéfice** = marge / coût de fabrication (gérer division par zéro →
   null, pas d'erreur).
5. **Statut** = "OK" si `NiveauJoueur.niveau >= Recette.niveau_requis` pour
   le métier concerné, sinon "Niveau insuffisant".
6. **Top rentabilité** = recettes triées par % Bénéfice décroissant, filtre
   optionnel `accessible_only`.

## Authentification

- Un seul utilisateur, créé via `bin/console app:create-user email password`
  (pas d'inscription publique).
- Toutes les routes API sont protégées par JWT, sauf `/api/login_check`.
- Le frontend affiche un écran de login tant qu'aucun token valide n'est
  présent ; aucune route de l'app n'est visible sans être connecté.

## Workflow de développement (important)

Le projet avance par sprints (0 à 6), chacun avec une "Definition of Done"
précise. Règles à respecter :
- Ne pas commencer un sprint tant que le précédent n'est pas validé.
- Tenir `KANBAN.md` à jour (colonnes Backlog / À faire / En cours / En revue
  / Terminé) : déplacer une carte AVANT de coder dessus, pas après.
- Si les issues GitHub existent déjà (labels `sprint:0` à `sprint:6`), les
  utiliser comme source de vérité plutôt que de redéfinir les tâches.
- Toujours livrer quelque chose de testable/lançable à la fin d'un sprint
  (`docker compose up` doit fonctionner à tout moment sur `main`).

## Conventions de code

- Backend : suivre les conventions Symfony standard (PSR-12), un service
  dédié pour la logique de calcul (`CoutCalculator` ou équivalent), ne pas
  mettre de logique métier dans les contrôleurs/ressources API Platform.
- Frontend : composants fonctionnels + hooks, un hook React Query par
  ressource API (`useRecettes`, `useTopRentabilite`, etc.), pas d'appel
  fetch direct dans les composants.
- Toute nouvelle règle de calcul doit avoir un test PHPUnit associé.
- Ne jamais committer de `.env.local` ou de secrets.

## Commandes utiles

```bash
docker compose up -d              # lance toute la stack
docker compose exec backend bin/console doctrine:migrations:migrate
docker compose exec backend bin/console doctrine:fixtures:load
docker compose exec backend bin/console app:create-user <email> <password>
docker compose exec backend bin/phpunit
docker compose exec frontend npm run test
```

## Ce qu'il ne faut PAS faire

- Ne pas ouvrir l'inscription publique (un seul utilisateur pour le moment).
- Ne pas calculer marge/%/statut côté frontend : tout vient de l'API.
- Ne pas mettre un objet obtenu sur un monstre dans `Ressource`.
- Ne pas sauter un sprint sans que sa Definition of Done soit remplie.
