<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Migration initiale vide : valide la connexion Doctrine ↔ PostgreSQL
 * et initialise la table doctrine_migration_versions.
 */
final class Version20260930005117 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Migration initiale vide (socle Doctrine + PostgreSQL)';
    }

    public function up(Schema $schema): void
    {
    }

    public function down(Schema $schema): void
    {
    }
}
