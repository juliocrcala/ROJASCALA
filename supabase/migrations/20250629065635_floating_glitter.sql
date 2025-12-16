/*
  # Cleanup contacts data and fix inconsistencies

  1. Data Cleanup
    - Remove any orphaned references
    - Ensure data consistency
    - Reset any problematic states

  2. Verification
    - Check for existing contacts
    - Validate data integrity
    - Create default contact if needed

  3. Security
    - Maintain existing RLS policies
    - Ensure proper permissions
*/

-- First, let's see what contacts exist
DO $$
DECLARE
    contact_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO contact_count FROM contacts;
    RAISE NOTICE 'Current contacts count: %', contact_count;
END $$;

-- Clean up any potential data inconsistencies
-- Remove any articles referencing non-existent contacts
UPDATE articles 
SET author_contact_id = NULL 
WHERE author_contact_id IS NOT NULL 
AND author_contact_id NOT IN (SELECT id FROM contacts);

UPDATE special_articles 
SET author_contact_id = NULL 
WHERE author_contact_id IS NOT NULL 
AND author_contact_id NOT IN (SELECT id FROM contacts);

-- Ensure we have at least one default contact
INSERT INTO contacts (
    name, 
    email, 
    linkedin_url, 
    instagram_url, 
    bio,
    job_title,
    is_active
) 
VALUES (
    'Julio Cesar Rojas Cala',
    'julio.cesar@rojascala.org',
    'https://www.linkedin.com/in/julio-cesar-rojas-cala-069883238/',
    'https://www.instagram.com/jc_rojascala/?hl=es-la',
    'Especialista en análisis de normas legales y regulaciones.',
    'Especialista Legal',
    true
) 
ON CONFLICT (email) DO UPDATE SET
    name = EXCLUDED.name,
    linkedin_url = EXCLUDED.linkedin_url,
    instagram_url = EXCLUDED.instagram_url,
    bio = EXCLUDED.bio,
    job_title = EXCLUDED.job_title,
    is_active = EXCLUDED.is_active,
    updated_at = now();

-- Update articles to link with the default contact where author matches
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

-- Final verification
DO $$
DECLARE
    final_count INTEGER;
    default_contact_id UUID;
BEGIN
    SELECT COUNT(*) INTO final_count FROM contacts;
    SELECT id INTO default_contact_id FROM contacts WHERE email = 'julio.cesar@rojascala.org';
    
    RAISE NOTICE 'Final contacts count: %', final_count;
    RAISE NOTICE 'Default contact ID: %', default_contact_id;
END $$;