/*
  # SCRIPT COMPLETO DE CONFIGURACIÓN DE BASE DE DATOS
  # Ejecutar este script en el panel de Supabase para crear todas las tablas necesarias
  
  Este script crea:
  1. Tabla articles (artículos normativos)
  2. Tabla special_articles (artículos especiales)
  3. Tabla contacts (contactos/autores)
  4. Tabla consultations (consultas de usuarios)
  5. Tabla categories_config (configuración de categorías y tipos)
  6. Todas las políticas RLS necesarias
  7. Datos iniciales por defecto
*/

-- =====================================================
-- 1. CREAR TABLA DE ARTÍCULOS NORMATIVOS
-- =====================================================

CREATE TABLE IF NOT EXISTS articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL DEFAULT 'Julio Cesar Rojas Cala',
  document_type text NOT NULL,
  published_date date NOT NULL,
  category text[] NOT NULL DEFAULT '{}',
  content text NOT NULL,
  summary text,
  official_link text,
  author_contact_id uuid,
  is_hidden boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para articles
DROP POLICY IF EXISTS "Public can read articles" ON articles;
DROP POLICY IF EXISTS "Public can create articles" ON articles;
DROP POLICY IF EXISTS "Public can update articles" ON articles;
DROP POLICY IF EXISTS "Public can delete articles" ON articles;

CREATE POLICY "Public can read articles" ON articles FOR SELECT TO public USING (true);
CREATE POLICY "Public can create articles" ON articles FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can update articles" ON articles FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete articles" ON articles FOR DELETE TO public USING (true);

-- Índices para articles
CREATE INDEX IF NOT EXISTS articles_published_date_idx ON articles(published_date DESC);
CREATE INDEX IF NOT EXISTS articles_categories_idx ON articles USING GIN(category);
CREATE INDEX IF NOT EXISTS articles_is_hidden_idx ON articles(is_hidden);

-- =====================================================
-- 2. CREAR TABLA DE ARTÍCULOS ESPECIALES
-- =====================================================

CREATE TABLE IF NOT EXISTS special_articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL DEFAULT 'Julio Cesar Rojas Cala',
  published_date date NOT NULL,
  category text[] NOT NULL DEFAULT '{}',
  content text NOT NULL,
  summary text,
  image_url text,
  author_contact_id uuid,
  is_hidden boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE special_articles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para special_articles
DROP POLICY IF EXISTS "Public can read special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can create special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can update special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can delete special articles" ON special_articles;

CREATE POLICY "Public can read special articles" ON special_articles FOR SELECT TO public USING (true);
CREATE POLICY "Public can create special articles" ON special_articles FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can update special articles" ON special_articles FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete special articles" ON special_articles FOR DELETE TO public USING (true);

-- Índices para special_articles
CREATE INDEX IF NOT EXISTS special_articles_published_date_idx ON special_articles(published_date DESC);
CREATE INDEX IF NOT EXISTS special_articles_categories_idx ON special_articles USING GIN(category);
CREATE INDEX IF NOT EXISTS special_articles_is_hidden_idx ON special_articles(is_hidden);

-- =====================================================
-- 3. CREAR TABLA DE CONTACTOS
-- =====================================================

CREATE TABLE IF NOT EXISTS contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  photo_url text,
  linkedin_url text,
  instagram_url text,
  bio text,
  services_link text,
  job_title text DEFAULT 'Especialista Legal',
  services_description text,
  is_active boolean DEFAULT true,
  display_order integer DEFAULT 999,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para contacts
DROP POLICY IF EXISTS "Anyone can read active contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can create contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can update contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can delete contacts" ON contacts;

CREATE POLICY "Anyone can read active contacts" ON contacts FOR SELECT USING (is_active = true);
CREATE POLICY "Anyone can create contacts" ON contacts FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update contacts" ON contacts FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete contacts" ON contacts FOR DELETE USING (true);

-- Índices para contacts
CREATE INDEX IF NOT EXISTS contacts_email_idx ON contacts(email);
CREATE INDEX IF NOT EXISTS contacts_is_active_idx ON contacts(is_active);
CREATE INDEX IF NOT EXISTS contacts_display_order_idx ON contacts(display_order, created_at);

-- =====================================================
-- 4. CREAR TABLA DE CONSULTAS
-- =====================================================

CREATE TABLE IF NOT EXISTS consultations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  message text NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'read', 'replied')),
  admin_notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE consultations ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para consultations
DROP POLICY IF EXISTS "Anyone can create consultations" ON consultations;
DROP POLICY IF EXISTS "Public can read consultations" ON consultations;
DROP POLICY IF EXISTS "Public can update consultations" ON consultations;
DROP POLICY IF EXISTS "Public can delete consultations" ON consultations;

CREATE POLICY "Anyone can create consultations" ON consultations FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can read consultations" ON consultations FOR SELECT TO public USING (true);
CREATE POLICY "Public can update consultations" ON consultations FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete consultations" ON consultations FOR DELETE TO public USING (true);

-- Índices para consultations
CREATE INDEX IF NOT EXISTS consultations_status_idx ON consultations(status);
CREATE INDEX IF NOT EXISTS consultations_created_at_idx ON consultations(created_at DESC);
CREATE INDEX IF NOT EXISTS consultations_email_idx ON consultations(email);

-- =====================================================
-- 5. CREAR TABLA DE CONFIGURACIÓN DE CATEGORÍAS
-- =====================================================

CREATE TABLE IF NOT EXISTS categories_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('category', 'document_type')),
  display_order integer DEFAULT 999,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(name, type)
);

-- Enable Row Level Security
ALTER TABLE categories_config ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para categories_config
DROP POLICY IF EXISTS "Public can read active categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can create categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can update categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can delete categories config" ON categories_config;

CREATE POLICY "Public can read active categories config" ON categories_config FOR SELECT TO public USING (is_active = true);
CREATE POLICY "Public can create categories config" ON categories_config FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can update categories config" ON categories_config FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete categories config" ON categories_config FOR DELETE TO public USING (true);

-- Índices para categories_config
CREATE INDEX IF NOT EXISTS categories_config_type_idx ON categories_config(type);
CREATE INDEX IF NOT EXISTS categories_config_active_idx ON categories_config(is_active);
CREATE INDEX IF NOT EXISTS categories_config_order_idx ON categories_config(display_order);

-- =====================================================
-- 6. FUNCIONES DE ACTUALIZACIÓN AUTOMÁTICA
-- =====================================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para actualizar updated_at
DROP TRIGGER IF EXISTS update_articles_updated_at ON articles;
DROP TRIGGER IF EXISTS update_special_articles_updated_at ON special_articles;
DROP TRIGGER IF EXISTS update_contacts_updated_at ON contacts;
DROP TRIGGER IF EXISTS update_consultations_updated_at ON consultations;
DROP TRIGGER IF EXISTS update_categories_config_updated_at ON categories_config;

CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_special_articles_updated_at BEFORE UPDATE ON special_articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON contacts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_consultations_updated_at BEFORE UPDATE ON consultations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_config_updated_at BEFORE UPDATE ON categories_config
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 7. AGREGAR FOREIGN KEYS (después de crear contacts)
-- =====================================================

-- Agregar foreign keys si no existen
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'articles_author_contact_fk'
  ) THEN
    ALTER TABLE articles ADD CONSTRAINT articles_author_contact_fk 
      FOREIGN KEY (author_contact_id) REFERENCES contacts(id);
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'special_articles_author_contact_fk'
  ) THEN
    ALTER TABLE special_articles ADD CONSTRAINT special_articles_author_contact_fk 
      FOREIGN KEY (author_contact_id) REFERENCES contacts(id);
  END IF;
END $$;

-- =====================================================
-- 8. INSERTAR DATOS INICIALES
-- =====================================================

-- Insertar contacto por defecto
INSERT INTO contacts (
  name, 
  email, 
  linkedin_url, 
  instagram_url, 
  bio,
  job_title,
  is_active,
  display_order
) VALUES (
  'Julio Cesar Rojas Cala',
  'julio.cesar@rojascala.org',
  'https://www.linkedin.com/in/julio-cesar-rojas-cala-069883238/',
  'https://www.instagram.com/jc_rojascala/?hl=es-la',
  'Especialista en análisis de normas legales y regulaciones.',
  'Especialista Legal',
  true,
  1
) ON CONFLICT (email) DO UPDATE SET
  name = EXCLUDED.name,
  linkedin_url = EXCLUDED.linkedin_url,
  instagram_url = EXCLUDED.instagram_url,
  bio = EXCLUDED.bio,
  job_title = EXCLUDED.job_title,
  is_active = EXCLUDED.is_active,
  display_order = EXCLUDED.display_order,
  updated_at = now();

-- Insertar tipos de documentos por defecto
INSERT INTO categories_config (name, type, display_order, is_active) VALUES
  ('Ley', 'document_type', 1, true),
  ('Decreto Supremo', 'document_type', 2, true),
  ('Resolución Ministerial', 'document_type', 3, true),
  ('Resolución Directoral', 'document_type', 4, true),
  ('Ordenanza', 'document_type', 5, true),
  ('Acuerdo', 'document_type', 6, true),
  ('Directiva', 'document_type', 7, true),
  ('Reglamento', 'document_type', 8, true),
  ('Decreto Legislativo', 'document_type', 9, true),
  ('Resolución Suprema', 'document_type', 10, true)
ON CONFLICT (name, type) DO NOTHING;

-- Insertar categorías por defecto
INSERT INTO categories_config (name, type, display_order, is_active) VALUES
  ('Constitucional', 'category', 1, true),
  ('Administrativo', 'category', 2, true),
  ('Civil', 'category', 3, true),
  ('Penal', 'category', 4, true),
  ('Laboral', 'category', 5, true),
  ('Tributario', 'category', 6, true),
  ('Ambiental', 'category', 7, true),
  ('Comercial', 'category', 8, true),
  ('Familia', 'category', 9, true),
  ('Sucesión', 'category', 10, true),
  ('Minero', 'category', 11, true),
  ('Energético', 'category', 12, true),
  ('Educativo', 'category', 13, true),
  ('Sanitario', 'category', 14, true),
  ('Municipal', 'category', 15, true)
ON CONFLICT (name, type) DO NOTHING;

-- Insertar algunas consultas de ejemplo
INSERT INTO consultations (name, email, message, status) VALUES
  ('María García', 'maria@ejemplo.com', '¿Podrían ayudarme con un tema de contratos laborales?', 'pending'),
  ('Carlos López', 'carlos@ejemplo.com', 'Necesito asesoría sobre herencias y testamentos.', 'read'),
  ('Ana Rodríguez', 'ana@ejemplo.com', 'Tengo dudas sobre la nueva ley de protección de datos.', 'replied')
ON CONFLICT DO NOTHING;

-- =====================================================
-- 9. VERIFICACIÓN FINAL
-- =====================================================

-- Verificar que todas las tablas se crearon correctamente
DO $$
DECLARE
    table_count INTEGER;
    articles_count INTEGER;
    contacts_count INTEGER;
    categories_count INTEGER;
    consultations_count INTEGER;
BEGIN
    -- Contar tablas creadas
    SELECT COUNT(*) INTO table_count 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name IN ('articles', 'special_articles', 'contacts', 'consultations', 'categories_config');
    
    -- Contar registros en cada tabla
    SELECT COUNT(*) INTO articles_count FROM articles;
    SELECT COUNT(*) INTO contacts_count FROM contacts;
    SELECT COUNT(*) INTO categories_count FROM categories_config;
    SELECT COUNT(*) INTO consultations_count FROM consultations;
    
    RAISE NOTICE '=== VERIFICACIÓN COMPLETADA ===';
    RAISE NOTICE 'Tablas creadas: % de 5', table_count;
    RAISE NOTICE 'Contactos: %', contacts_count;
    RAISE NOTICE 'Categorías y tipos: %', categories_count;
    RAISE NOTICE 'Consultas de ejemplo: %', consultations_count;
    RAISE NOTICE 'Artículos: %', articles_count;
    
    IF table_count = 5 THEN
        RAISE NOTICE '✅ ¡BASE DE DATOS CONFIGURADA CORRECTAMENTE!';
    ELSE
        RAISE NOTICE '❌ Faltan tablas por crear';
    END IF;
END $$;