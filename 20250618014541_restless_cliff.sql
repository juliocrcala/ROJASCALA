/*
  # Create articles management system

  1. New Tables
    - `articles`
      - `id` (uuid, primary key)
      - `title` (text, required) - Título del artículo
      - `author` (text, required) - Autor del artículo
      - `document_type` (text, required) - Tipo de documento (Ley, Decreto, etc.)
      - `published_date` (date, required) - Fecha de publicación
      - `category` (text, required) - Categoría legal
      - `content` (text, required) - Contenido completo del análisis
      - `summary` (text) - Resumen del artículo
      - `official_link` (text) - Enlace a la norma oficial
      - `created_at` (timestamp) - Fecha de creación
      - `updated_at` (timestamp) - Fecha de actualización

  2. Security
    - Enable RLS on `articles` table
    - Add policies for public reading and authenticated writing
*/

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

-- Allow everyone to read articles (public access)
CREATE POLICY "Anyone can read articles"
  ON articles
  FOR SELECT
  USING (true);

-- Allow authenticated users to insert articles
CREATE POLICY "Authenticated users can create articles"
  ON articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update articles
CREATE POLICY "Authenticated users can update articles"
  ON articles
  FOR UPDATE
  TO authenticated
  USING (true);

-- Allow authenticated users to delete articles
CREATE POLICY "Authenticated users can delete articles"
  ON articles
  FOR DELETE
  TO authenticated
  USING (true);

-- Create an index for better performance on date queries
CREATE INDEX IF NOT EXISTS articles_published_date_idx ON articles(published_date DESC);
CREATE INDEX IF NOT EXISTS articles_category_idx ON articles(category);
CREATE INDEX IF NOT EXISTS articles_document_type_idx ON articles(document_type);