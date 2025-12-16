/*
  # Add job_title and services_description fields to contacts table

  1. Modifications
    - Add `job_title` column to `contacts` table for professional title
    - Add `services_description` column to `contacts` table for services description

  2. Notes
    - Both fields are optional and have default values for existing records
    - job_title defaults to 'Especialista Legal' for consistency
*/

-- Add job_title column to contacts table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'job_title'
  ) THEN
    ALTER TABLE contacts ADD COLUMN job_title text DEFAULT 'Especialista Legal';
  END IF;
END $$;

-- Add services_description column to contacts table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'services_description'
  ) THEN
    ALTER TABLE contacts ADD COLUMN services_description text;
  END IF;
END $$;

-- Update existing contact with default job title if not set
UPDATE contacts 
SET job_title = 'Especialista Legal' 
WHERE job_title IS NULL OR job_title = '';