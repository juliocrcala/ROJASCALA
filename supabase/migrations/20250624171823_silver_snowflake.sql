/*
  # Create special articles table

  1. New Tables
    - `special_articles`
      - `id` (uuid, primary key)
      - `title` (text, required) - Título del artículo especial
      - `author` (text, required) - Autor del artículo
      - `published_date` (date, required) - Fecha de publicación
      - `category` (text, required) - Categoría legal (solo categorías, no tipos de norma)
      - `content` (text, required) - Contenido completo del artículo
      - `summary` (text) - Resumen del artículo
      - `image_url` (text) - URL de la imagen del artículo
      - `created_at` (timestamp) - Fecha de creación
      - `updated_at` (timestamp) - Fecha de actualización

  2. Security
    - Enable RLS on `special_articles` table
    - Add policies for public reading and authenticated writing
*/

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

-- Allow everyone to read special articles (public access)
CREATE POLICY "Anyone can read special articles"
  ON special_articles
  FOR SELECT
  USING (true);

-- Allow authenticated users to insert special articles
CREATE POLICY "Authenticated users can create special articles"
  ON special_articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update special articles
CREATE POLICY "Authenticated users can update special articles"
  ON special_articles
  FOR UPDATE
  TO authenticated
  USING (true);

-- Allow authenticated users to delete special articles
CREATE POLICY "Authenticated users can delete special articles"
  ON special_articles
  FOR DELETE
  TO authenticated
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS special_articles_published_date_idx ON special_articles(published_date DESC);
CREATE INDEX IF NOT EXISTS special_articles_category_idx ON special_articles(category);