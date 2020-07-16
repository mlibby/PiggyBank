DO $$
DECLARE
    migration_level INTEGER;
BEGIN
    CREATE TABLE IF NOT EXISTS migration (
        level INTEGER
    );
    SELECT
        MAX(level) INTO migration_level
    FROM
        migration;
    IF migration_level IS NULL THEN
        INSERT INTO migration
        VALUES (0);
    END IF;
END
$$;

