-- EJECUTAR ESTE SCRIPT EN TU PANEL DE SUPABASE
-- Ve a: https://supabase.com/dashboard/project/kyekcfjulzgvziqpyfod/sql

-- =====================================================
-- SCRIPT 1: Crear tabla de artículos normativos
-- =====================================================

CREATE TABLE IF NOT EXISTS articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL DEFAULT 'Julio Cesar Rojas Cala',
  document_type text NOT NULL,
  published_date date NOT NULL,
  category text NOT NULL,
  content text NOT NULL,
  summary text,
  official_link text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para articles
CREATE POLICY "Anyone can read articles"
  ON articles
  FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create articles"
  ON articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update articles"
  ON articles
  FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete articles"
  ON articles
  FOR DELETE
  TO authenticated
  USING (true);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS articles_published_date_idx ON articles(published_date DESC);
CREATE INDEX IF NOT EXISTS articles_category_idx ON articles(category);
CREATE INDEX IF NOT EXISTS articles_document_type_idx ON articles(document_type);

-- =====================================================
-- SCRIPT 2: Crear tabla de artículos especiales
-- =====================================================

CREATE TABLE IF NOT EXISTS special_articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL DEFAULT 'Julio Cesar Rojas Cala',
  published_date date NOT NULL,
  category text NOT NULL,
  content text NOT NULL,
  summary text,
  image_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE special_articles ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para special_articles
CREATE POLICY "Anyone can read special articles"
  ON special_articles
  FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create special articles"
  ON special_articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update special articles"
  ON special_articles
  FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete special articles"
  ON special_articles
  FOR DELETE
  TO authenticated
  USING (true);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS special_articles_published_date_idx ON special_articles(published_date DESC);
CREATE INDEX IF NOT EXISTS special_articles_category_idx ON special_articles(category);

-- =====================================================
-- VERIFICACIÓN: Comprobar que las tablas se crearon
-- =====================================================

-- Ejecuta esto para verificar que las tablas existen:
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('articles', 'special_articles');