/*
  # Add support for multiple categories in articles

  1. Modifications
    - Change `category` column from text to text array in both `articles` and `special_articles` tables
    - Update existing data to convert single categories to arrays
    - Add indexes for better performance on array queries

  2. Notes
    - This allows articles to belong to multiple categories
    - Existing single categories will be converted to single-item arrays
    - New articles can have multiple categories selected
*/

-- Update articles table to support multiple categories
ALTER TABLE articles 
ALTER COLUMN category TYPE text[] USING ARRAY[category];

-- Update special_articles table to support multiple categories  
ALTER TABLE special_articles 
ALTER COLUMN category TYPE text[] USING ARRAY[category];

-- Add indexes for better performance on array queries
CREATE INDEX IF NOT EXISTS articles_categories_idx ON articles USING GIN(category);
CREATE INDEX IF NOT EXISTS special_articles_categories_idx ON special_articles USING GIN(category);

-- Update any existing single null values to empty arrays
UPDATE articles SET category = '{}' WHERE category IS NULL;
UPDATE special_articles SET category = '{}' WHERE category IS NULL;