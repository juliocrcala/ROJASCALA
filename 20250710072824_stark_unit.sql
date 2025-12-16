/*
  # Create consultations table for managing user inquiries

  1. New Tables
    - `consultations`
      - `id` (uuid, primary key)
      - `name` (text, required) - Nombre del consultante
      - `email` (text, required) - Email del consultante
      - `message` (text, required) - Mensaje/consulta
      - `status` (text, default 'pending') - Estado: pending, read, replied
      - `admin_notes` (text) - Notas internas del admin
      - `created_at` (timestamp) - Fecha de creación
      - `updated_at` (timestamp) - Fecha de actualización

  2. Security
    - Enable RLS on `consultations` table
    - Add policies for public creation and admin management

  3. Indexes
    - Index on status for filtering
    - Index on created_at for ordering
*/

-- Create consultations table
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

-- Allow anyone to create consultations (public form submissions)
CREATE POLICY "Anyone can create consultations"
  ON consultations
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Allow public to read all consultations (for admin panel)
CREATE POLICY "Public can read consultations"
  ON consultations
  FOR SELECT
  TO public
  USING (true);

-- Allow public to update consultations (for admin panel)
CREATE POLICY "Public can update consultations"
  ON consultations
  FOR UPDATE
  TO public
  USING (true);

-- Allow public to delete consultations (for admin panel)
CREATE POLICY "Public can delete consultations"
  ON consultations
  FOR DELETE
  TO public
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS consultations_status_idx ON consultations(status);
CREATE INDEX IF NOT EXISTS consultations_created_at_idx ON consultations(created_at DESC);
CREATE INDEX IF NOT EXISTS consultations_email_idx ON consultations(email);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_consultations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_consultations_updated_at_trigger
  BEFORE UPDATE ON consultations
  FOR EACH ROW
  EXECUTE FUNCTION update_consultations_updated_at();

-- Insert some example data for testing (optional)
INSERT INTO consultations (name, email, message, status) VALUES
  ('María García', 'maria@ejemplo.com', '¿Podrían ayudarme con un tema de contratos laborales?', 'pending'),
  ('Carlos López', 'carlos@ejemplo.com', 'Necesito asesoría sobre herencias y testamentos.', 'read'),
  ('Ana Rodríguez', 'ana@ejemplo.com', 'Tengo dudas sobre la nueva ley de protección de datos.', 'replied')
ON CONFLICT DO NOTHING;