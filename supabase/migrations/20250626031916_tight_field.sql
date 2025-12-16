/*
  # Create contacts table for author management

  1. New Tables
    - `contacts`
      - `id` (uuid, primary key)
      - `name` (text, required) - Nombre completo del contacto
      - `email` (text, required, unique) - Correo electrónico
      - `photo_url` (text) - URL de la foto de perfil
      - `linkedin_url` (text) - URL de LinkedIn
      - `instagram_url` (text) - URL de Instagram
      - `bio` (text) - Biografía opcional
      - `is_active` (boolean) - Si el contacto está activo
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Modifications to existing tables
    - Add `author_contact_id` to `articles` table
    - Add `author_contact_id` to `special_articles` table

  3. Security
    - Enable RLS on `contacts` table
    - Add policies for public reading and authenticated writing
*/

-- Create contacts table
CREATE TABLE IF NOT EXISTS contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  photo_url text,
  linkedin_url text,
  instagram_url text,
  bio text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read active contacts (public access)
CREATE POLICY "Anyone can read active contacts"
  ON contacts
  FOR SELECT
  USING (is_active = true);

-- Allow authenticated users to manage contacts
CREATE POLICY "Authenticated users can create contacts"
  ON contacts
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update contacts"
  ON contacts
  FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can delete contacts"
  ON contacts
  FOR DELETE
  TO authenticated
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS contacts_email_idx ON contacts(email);
CREATE INDEX IF NOT EXISTS contacts_is_active_idx ON contacts(is_active);

-- Insert default contact (Julio Cesar Rojas Cala)
INSERT INTO contacts (name, email, linkedin_url, instagram_url, bio) 
VALUES (
  'Julio Cesar Rojas Cala',
  'julio.cesar@rojascala.org',
  'https://www.linkedin.com/in/julio-cesar-rojas-cala-069883238/',
  'https://www.instagram.com/jc_rojascala/?hl=es-la',
  'Especialista en análisis de normas legales y regulaciones.'
) ON CONFLICT (email) DO NOTHING;

-- Add author_contact_id to articles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'articles' AND column_name = 'author_contact_id'
  ) THEN
    ALTER TABLE articles ADD COLUMN author_contact_id uuid REFERENCES contacts(id);
  END IF;
END $$;

-- Add author_contact_id to special_articles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'special_articles' AND column_name = 'author_contact_id'
  ) THEN
    ALTER TABLE special_articles ADD COLUMN author_contact_id uuid REFERENCES contacts(id);
  END IF;
END $$;

-- Update existing articles to link with default contact
UPDATE articles 
SET author_contact_id = (
  SELECT id FROM contacts WHERE email = 'julio.cesar@rojascala.org' LIMIT 1
)
WHERE author = 'Julio Cesar Rojas Cala' AND author_contact_id IS NULL;

UPDATE special_articles 
SET author_contact_id = (
  SELECT id FROM contacts WHERE email = 'julio.cesar@rojascala.org' LIMIT 1
)
WHERE author = 'Julio Cesar Rojas Cala' AND author_contact_id IS NULL;