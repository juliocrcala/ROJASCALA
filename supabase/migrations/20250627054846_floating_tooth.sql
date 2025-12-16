/*
  # Add services_link column to contacts table

  1. Modifications
    - Add `services_link` column to `contacts` table for storing links to service documents (PDFs, etc.)

  2. Notes
    - This allows contacts to link to their professional services documentation
    - The field is optional and can store URLs to Google Drive, Dropbox, or other document hosting services
*/

-- Add services_link column to contacts table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'services_link'
  ) THEN
    ALTER TABLE contacts ADD COLUMN services_link text;
  END IF;
END $$;