/*
  # Add is_hidden field to special_articles table

  1. Modifications
    - Add `is_hidden` column to `special_articles` table for hiding articles
    - Default value is false (visible)
    - Add index for better performance on visibility queries

  2. Notes
    - This allows admins to hide articles without deleting them
    - Hidden articles won't appear in public views
    - Can be toggled on/off from admin panel
*/

-- Add is_hidden column to special_articles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'special_articles' AND column_name = 'is_hidden'
  ) THEN
    ALTER TABLE special_articles ADD COLUMN is_hidden boolean DEFAULT false;
  END IF;
END $$;

-- Create index for better performance on visibility queries
CREATE INDEX IF NOT EXISTS special_articles_is_hidden_idx ON special_articles(is_hidden);

-- Ensure all existing articles are visible by default
UPDATE special_articles SET is_hidden = false WHERE is_hidden IS NULL;