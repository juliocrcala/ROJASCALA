/*
  # Create articles table and related schemas

  1. New Tables
    - `articles`
      - `id` (uuid, primary key)
      - `title` (text, required)
      - `author` (text, required)
      - `document_type` (text, required)
      - `published_date` (date, required)
      - `category` (text, required)
      - `content` (text, required)
      - `official_link` (text, optional)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `articles` table
    - Add policies for article management
*/

CREATE TABLE articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL,
  document_type text NOT NULL,
  published_date date NOT NULL,
  category text NOT NULL,
  content text NOT NULL,
  official_link text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read all articles
CREATE POLICY "Anyone can read articles"
  ON articles
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow authenticated users to create articles
CREATE POLICY "Authenticated users can create articles"
  ON articles
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update their own articles
CREATE POLICY "Users can update their own articles"
  ON articles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IN (
    SELECT auth.uid()
    FROM auth.users
    WHERE auth.users.email = articles.author
  ));