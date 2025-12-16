/*
  # Add ordering system to contacts table

  1. Modifications
    - Add `display_order` column to `contacts` table for custom ordering
    - Add index for better performance on ordering queries
    - Update existing contacts with sequential order numbers

  2. Notes
    - Lower numbers appear first (1, 2, 3...)
    - New contacts get the highest order number by default
    - Admins can reorder contacts by changing the display_order value
*/

-- Add display_order column to contacts table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'contacts' AND column_name = 'display_order'
  ) THEN
    ALTER TABLE contacts ADD COLUMN display_order integer DEFAULT 999;
  END IF;
END $$;

-- Create index for better performance on ordering
CREATE INDEX IF NOT EXISTS contacts_display_order_idx ON contacts(display_order, created_at);

-- Update existing contacts with sequential order numbers
WITH ordered_contacts AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at) as new_order
  FROM contacts
  WHERE display_order IS NULL OR display_order = 999
)
UPDATE contacts 
SET display_order = ordered_contacts.new_order
FROM ordered_contacts
WHERE contacts.id = ordered_contacts.id;

-- Ensure no null values
UPDATE contacts SET display_order = 999 WHERE display_order IS NULL;