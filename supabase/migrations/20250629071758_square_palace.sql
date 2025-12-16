/*
  # Agregar columna display_order a la tabla contacts

  1. Modificaciones
    - Agregar columna `display_order` a la tabla `contacts`
    - Asignar valores secuenciales a contactos existentes
    - Crear índice para mejor rendimiento

  2. Notas
    - Esta columna permite ordenar los contactos manualmente
    - Los contactos existentes recibirán números secuenciales
    - Los nuevos contactos se agregarán al final por defecto
*/

-- Agregar la columna display_order si no existe
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'display_order'
  ) THEN
    ALTER TABLE contacts ADD COLUMN display_order integer DEFAULT 999;
    RAISE NOTICE 'Columna display_order agregada exitosamente';
  ELSE
    RAISE NOTICE 'Columna display_order ya existe';
  END IF;
END $$;

-- Crear índice para mejor rendimiento en ordenamiento
CREATE INDEX IF NOT EXISTS contacts_display_order_idx ON contacts(display_order, created_at);

-- Asignar números de orden secuenciales a contactos existentes
WITH ordered_contacts AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at) as new_order
  FROM contacts
  WHERE display_order IS NULL OR display_order = 999
)
UPDATE contacts 
SET display_order = ordered_contacts.new_order
FROM ordered_contacts
WHERE contacts.id = ordered_contacts.id;

-- Asegurar que no hay valores nulos
UPDATE contacts SET display_order = 999 WHERE display_order IS NULL;

-- Verificar que todo está correcto
DO $$
DECLARE
    contact_count INTEGER;
    min_order INTEGER;
    max_order INTEGER;
BEGIN
    SELECT COUNT(*), MIN(display_order), MAX(display_order) 
    INTO contact_count, min_order, max_order 
    FROM contacts;
    
    RAISE NOTICE 'Contactos totales: %, Orden mínimo: %, Orden máximo: %', 
                 contact_count, min_order, max_order;
END $$;