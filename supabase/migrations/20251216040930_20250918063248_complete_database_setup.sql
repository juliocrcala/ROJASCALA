/*
  # Configuración completa de base de datos Rojas Cala
  
  Crea todas las tablas necesarias con campos actualizados:
  1. articles - con is_hidden, author_contact_id, category como array
  2. special_articles - con is_hidden, author_contact_id, category como array
  3. contacts - perfiles de especialistas
  4. consultations - sistema de consultas
  5. categories_config - configuración de categorías y tipos
*/

-- =====================================================
-- 1. TABLA DE ARTÍCULOS NORMATIVOS
-- =====================================================

DO $$
BEGIN
  -- Agregar columnas faltantes si no existen
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='articles' AND column_name='is_hidden') THEN
    ALTER TABLE articles ADD COLUMN is_hidden boolean DEFAULT false;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='articles' AND column_name='author_contact_id') THEN
    ALTER TABLE articles ADD COLUMN author_contact_id uuid;
  END IF;
  
  -- Cambiar category de text a text[] si es necesario
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name='articles' AND column_name='category' AND data_type='text'
  ) THEN
    ALTER TABLE articles ALTER COLUMN category TYPE text[] USING ARRAY[category];
  END IF;
END $$;

-- Índices adicionales
CREATE INDEX IF NOT EXISTS articles_is_hidden_idx ON articles(is_hidden);
CREATE INDEX IF NOT EXISTS articles_categories_idx ON articles USING GIN(category);

-- =====================================================
-- 2. TABLA DE ARTÍCULOS ESPECIALES
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

ALTER TABLE special_articles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can create special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can update special articles" ON special_articles;
DROP POLICY IF EXISTS "Public can delete special articles" ON special_articles;

CREATE POLICY "Public can read special articles" ON special_articles FOR SELECT TO public USING (true);
CREATE POLICY "Public can create special articles" ON special_articles FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can update special articles" ON special_articles FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete special articles" ON special_articles FOR DELETE TO public USING (true);

CREATE INDEX IF NOT EXISTS special_articles_published_date_idx ON special_articles(published_date DESC);
CREATE INDEX IF NOT EXISTS special_articles_categories_idx ON special_articles USING GIN(category);
CREATE INDEX IF NOT EXISTS special_articles_is_hidden_idx ON special_articles(is_hidden);

-- =====================================================
-- 3. TABLA DE CONTACTOS
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

ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read active contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can create contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can update contacts" ON contacts;
DROP POLICY IF EXISTS "Anyone can delete contacts" ON contacts;

CREATE POLICY "Anyone can read active contacts" ON contacts FOR SELECT USING (is_active = true);
CREATE POLICY "Anyone can create contacts" ON contacts FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update contacts" ON contacts FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete contacts" ON contacts FOR DELETE USING (true);

CREATE INDEX IF NOT EXISTS contacts_email_idx ON contacts(email);
CREATE INDEX IF NOT EXISTS contacts_is_active_idx ON contacts(is_active);
CREATE INDEX IF NOT EXISTS contacts_display_order_idx ON contacts(display_order, created_at);

-- =====================================================
-- 4. TABLA DE CONSULTAS
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

ALTER TABLE consultations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can create consultations" ON consultations;
DROP POLICY IF EXISTS "Public can read consultations" ON consultations;
DROP POLICY IF EXISTS "Public can update consultations" ON consultations;
DROP POLICY IF EXISTS "Public can delete consultations" ON consultations;

CREATE POLICY "Anyone can create consultations" ON consultations FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can read consultations" ON consultations FOR SELECT TO public USING (true);
CREATE POLICY "Public can update consultations" ON consultations FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete consultations" ON consultations FOR DELETE TO public USING (true);

CREATE INDEX IF NOT EXISTS consultations_status_idx ON consultations(status);
CREATE INDEX IF NOT EXISTS consultations_created_at_idx ON consultations(created_at DESC);
CREATE INDEX IF NOT EXISTS consultations_email_idx ON consultations(email);

-- =====================================================
-- 5. TABLA DE CONFIGURACIÓN DE CATEGORÍAS
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

ALTER TABLE categories_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read active categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can create categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can update categories config" ON categories_config;
DROP POLICY IF EXISTS "Public can delete categories config" ON categories_config;

CREATE POLICY "Public can read active categories config" ON categories_config FOR SELECT TO public USING (is_active = true);
CREATE POLICY "Public can create categories config" ON categories_config FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Public can update categories config" ON categories_config FOR UPDATE TO public USING (true);
CREATE POLICY "Public can delete categories config" ON categories_config FOR DELETE TO public USING (true);

CREATE INDEX IF NOT EXISTS categories_config_type_idx ON categories_config(type);
CREATE INDEX IF NOT EXISTS categories_config_active_idx ON categories_config(is_active);
CREATE INDEX IF NOT EXISTS categories_config_order_idx ON categories_config(display_order);

-- =====================================================
-- 6. DATOS INICIALES
-- =====================================================

INSERT INTO contacts (
  name, email, linkedin_url, instagram_url, bio, job_title, is_active, display_order
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
  ('Resolución Suprema', 'document_type', 10, true),
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
