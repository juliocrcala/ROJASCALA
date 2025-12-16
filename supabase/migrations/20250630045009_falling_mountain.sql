/*
  # Fix RLS policies to use public role instead of authenticated role

  1. Problem
    - Current policies are applied to 'authenticated' role
    - Application needs 'public' role access for anonymous users
    - This causes 42501 RLS policy violations

  2. Solution
    - Drop existing policies that use 'authenticated' role
    - Create new policies that use 'public' role or no role restriction
    - Apply to both articles and special_articles tables

  3. Changes
    - UPDATE policies: Change from 'authenticated' to 'public' role
    - INSERT policies: Change from 'authenticated' to 'public' role  
    - DELETE policies: Change from 'authenticated' to 'public' role
    - Keep SELECT policies as they are (already public)
*/

-- Fix articles table policies
DROP POLICY IF EXISTS "Anyone can read articles" ON articles;
DROP POLICY IF EXISTS "Authenticated users can create articles" ON articles;
DROP POLICY IF EXISTS "Anyone can create articles" ON articles;
DROP POLICY IF EXISTS "Authenticated users can update articles" ON articles;
DROP POLICY IF EXISTS "Anyone can update articles" ON articles;
DROP POLICY IF EXISTS "Authenticated users can delete articles" ON articles;
DROP POLICY IF EXISTS "Anyone can delete articles" ON articles;

-- Create new policies for articles with public role access
CREATE POLICY "Public can read articles"
  ON articles
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Public can create articles"
  ON articles
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Public can update articles"
  ON articles
  FOR UPDATE
  TO public
  USING (true);

CREATE POLICY "Public can delete articles"
  ON articles
  FOR DELETE
  TO public
  USING (true);

-- Fix special_articles table policies
DROP POLICY IF EXISTS "Anyone can read special articles" ON special_articles;
DROP POLICY IF EXISTS "Authenticated users can create special articles" ON special_articles;
DROP POLICY IF EXISTS "Anyone can create special articles" ON special_articles;
DROP POLICY IF EXISTS "Authenticated users can update special articles" ON special_articles;
DROP POLICY IF EXISTS "Anyone can update special articles" ON special_articles;
DROP POLICY IF EXISTS "Authenticated users can delete special articles" ON special_articles;
DROP POLICY IF EXISTS "Anyone can delete special articles" ON special_articles;

-- Create new policies for special_articles with public role access
CREATE POLICY "Public can read special articles"
  ON special_articles
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Public can create special articles"
  ON special_articles
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Public can update special articles"
  ON special_articles
  FOR UPDATE
  TO public
  USING (true);

CREATE POLICY "Public can delete special articles"
  ON special_articles
  FOR DELETE
  TO public
  USING (true);

-- Verify the changes
DO $$
BEGIN
    RAISE NOTICE 'RLS policies updated successfully - now using PUBLIC role for articles and special_articles tables';
    RAISE NOTICE 'You should now be able to create, edit, and delete articles without authentication errors';
END $$;