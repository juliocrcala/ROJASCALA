/*
  # Create categories configuration table

  1. New Tables
    - `categories_config`
      - `id` (uuid, primary key)
      - `name` (text, required) - Nombre de la categoría o tipo
      - `type` (text, required) - 'category' o 'document_type'
      - `display_order` (integer) - Orden de visualización
      - `is_active` (boolean) - Si está activo
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `categories_config` table
    - Add policies for public access

  3. Initial Data
    - Insert default categories and document types
*/

-- Create categories_config table
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

-- Allow public access for reading active items
CREATE POLICY "Public can read active categories config"
  ON categories_config
  FOR SELECT
  TO public
  USING (is_active = true);

-- Allow public access for admin management
CREATE POLICY "Public can create categories config"
  ON categories_config
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Public can update categories config"
  ON categories_config
  FOR UPDATE
  TO public
  USING (true);

CREATE POLICY "Public can delete categories config"
  ON categories_config
  FOR DELETE
  TO public
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS categories_config_type_idx ON categories_config(type);
CREATE INDEX IF NOT EXISTS categories_config_active_idx ON categories_config(is_active);
CREATE INDEX IF NOT EXISTS categories_config_order_idx ON categories_config(display_order);

-- Insert default document types
INSERT INTO categories_config (name, type, display_order, is_active) VALUES
  ('Ley', 'document_type', 1, true),
  ('Decreto Supremo', 'document_type', 2, true),
  ('Resolución Ministerial', 'document_type', 3, true),
  ('Resolución Directoral', 'document_type', 4, true),
  ('Ordenanza', 'document_type', 5, true),
  ('Acuerdo', 'document_type', 6, true),
  ('Directiva', 'document_type', 7, true),
  ('Reglamento', 'document_type', 8, true)
ON CONFLICT (name, type) DO NOTHING;

-- Insert default categories
INSERT INTO categories_config (name, type, display_order, is_active) VALUES
  ('Constitucional', 'category', 1, true),
  ('Administrativo', 'category', 2, true),
  ('Civil', 'category', 3, true),
  ('Penal', 'category', 4, true),
  ('Laboral', 'category', 5, true),
  ('Tributario', 'category', 6, true),
  ('Ambiental', 'category', 7, true),
  ('Comercial', 'category', 8, true)
ON CONFLICT (name, type) DO NOTHING;

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_categories_config_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_categories_config_updated_at_trigger
  BEFORE UPDATE ON categories_config
  FOR EACH ROW
  EXECUTE FUNCTION update_categories_config_updated_at();