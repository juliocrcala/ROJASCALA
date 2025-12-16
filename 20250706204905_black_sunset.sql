/*
  # Verificar y corregir la columna is_hidden en special_articles

  1. Verificación
    - Comprobar si la columna is_hidden existe en special_articles
    - Si no existe, crearla
    - Si existe pero tiene problemas, corregirla

  2. Correcciones
    - Asegurar que la columna tenga el tipo correcto (boolean)
    - Asegurar que tenga un valor por defecto (false)
    - Crear índice si no existe
    - Actualizar registros existentes
*/

-- Verificar y crear la columna is_hidden en special_articles si no existe
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'special_articles' AND column_name = 'is_hidden'
  ) THEN
    ALTER TABLE special_articles ADD COLUMN is_hidden boolean DEFAULT false;
    RAISE NOTICE 'Columna is_hidden agregada a special_articles';
  ELSE
    RAISE NOTICE 'Columna is_hidden ya existe en special_articles';
  END IF;
END $$;

-- Crear índice para mejor rendimiento en consultas de visibilidad
CREATE INDEX IF NOT EXISTS special_articles_is_hidden_idx ON special_articles(is_hidden);

-- Asegurar que todos los artículos especiales existentes sean visibles por defecto
UPDATE special_articles SET is_hidden = false WHERE is_hidden IS NULL;

-- Verificar que la columna funciona correctamente
DO $$
DECLARE
    column_exists boolean;
    total_articles integer;
    visible_articles integer;
    hidden_articles integer;
BEGIN
    -- Verificar que la columna existe
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'special_articles' AND column_name = 'is_hidden'
    ) INTO column_exists;
    
    IF column_exists THEN
        -- Contar artículos
        SELECT COUNT(*) INTO total_articles FROM special_articles;
        SELECT COUNT(*) INTO visible_articles FROM special_articles WHERE is_hidden = false;
        SELECT COUNT(*) INTO hidden_articles FROM special_articles WHERE is_hidden = true;
        
        RAISE NOTICE 'Verificación completada:';
        RAISE NOTICE '- Columna is_hidden existe: %', column_exists;
        RAISE NOTICE '- Total de artículos especiales: %', total_articles;
        RAISE NOTICE '- Artículos visibles: %', visible_articles;
        RAISE NOTICE '- Artículos ocultos: %', hidden_articles;
    ELSE
        RAISE EXCEPTION 'Error: La columna is_hidden no se pudo crear en special_articles';
    END IF;
END $$;