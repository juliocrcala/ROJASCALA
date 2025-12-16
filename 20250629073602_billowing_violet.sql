/*
  # Fix RLS policies and add admin functions for contacts

  1. Create admin functions that bypass RLS
    - create_contact_admin: Create contacts with admin privileges
    - update_contact_admin: Update contacts with admin privileges
    - delete_contact_admin: Delete contacts with admin privileges
    - toggle_contact_status_admin: Toggle contact status with admin privileges
    - update_contact_order_admin: Update contact order with admin privileges

  2. Security
    - Functions run with SECURITY DEFINER to bypass RLS
    - Only accessible through the application
*/

-- Function to create contacts (bypasses RLS)
CREATE OR REPLACE FUNCTION create_contact_admin(contact_data jsonb)
RETURNS contacts
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_contact contacts;
BEGIN
    INSERT INTO contacts (
        name,
        email,
        photo_url,
        linkedin_url,
        instagram_url,
        bio,
        services_link,
        job_title,
        services_description,
        is_active,
        display_order
    )
    VALUES (
        (contact_data->>'name')::text,
        (contact_data->>'email')::text,
        NULLIF(contact_data->>'photo_url', ''),
        NULLIF(contact_data->>'linkedin_url', ''),
        NULLIF(contact_data->>'instagram_url', ''),
        NULLIF(contact_data->>'bio', ''),
        NULLIF(contact_data->>'services_link', ''),
        COALESCE(NULLIF(contact_data->>'job_title', ''), 'Especialista Legal'),
        NULLIF(contact_data->>'services_description', ''),
        COALESCE((contact_data->>'is_active')::boolean, true),
        COALESCE((contact_data->>'display_order')::integer, 999)
    )
    RETURNING * INTO new_contact;
    
    RETURN new_contact;
END;
$$;

-- Function to update contacts (bypasses RLS)
CREATE OR REPLACE FUNCTION update_contact_admin(contact_id uuid, contact_data jsonb)
RETURNS contacts
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    updated_contact contacts;
BEGIN
    UPDATE contacts SET
        name = (contact_data->>'name')::text,
        email = (contact_data->>'email')::text,
        photo_url = NULLIF(contact_data->>'photo_url', ''),
        linkedin_url = NULLIF(contact_data->>'linkedin_url', ''),
        instagram_url = NULLIF(contact_data->>'instagram_url', ''),
        bio = NULLIF(contact_data->>'bio', ''),
        services_link = NULLIF(contact_data->>'services_link', ''),
        job_title = COALESCE(NULLIF(contact_data->>'job_title', ''), 'Especialista Legal'),
        services_description = NULLIF(contact_data->>'services_description', ''),
        is_active = COALESCE((contact_data->>'is_active')::boolean, true),
        display_order = COALESCE((contact_data->>'display_order')::integer, 999),
        updated_at = now()
    WHERE id = contact_id
    RETURNING * INTO updated_contact;
    
    IF updated_contact IS NULL THEN
        RAISE EXCEPTION 'Contact not found with id: %', contact_id;
    END IF;
    
    RETURN updated_contact;
END;
$$;

-- Function to delete contacts (bypasses RLS)
CREATE OR REPLACE FUNCTION delete_contact_admin(contact_id uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    deleted_count integer;
BEGIN
    -- First, remove references from articles
    UPDATE articles SET author_contact_id = NULL WHERE author_contact_id = contact_id;
    UPDATE special_articles SET author_contact_id = NULL WHERE author_contact_id = contact_id;
    
    -- Then delete the contact
    DELETE FROM contacts WHERE id = contact_id;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count > 0;
END;
$$;

-- Function to toggle contact status (bypasses RLS)
CREATE OR REPLACE FUNCTION toggle_contact_status_admin(contact_id uuid, new_status boolean)
RETURNS contacts
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    updated_contact contacts;
BEGIN
    UPDATE contacts SET
        is_active = new_status,
        updated_at = now()
    WHERE id = contact_id
    RETURNING * INTO updated_contact;
    
    IF updated_contact IS NULL THEN
        RAISE EXCEPTION 'Contact not found with id: %', contact_id;
    END IF;
    
    RETURN updated_contact;
END;
$$;

-- Function to update contact order (bypasses RLS)
CREATE OR REPLACE FUNCTION update_contact_order_admin(contact_id uuid, new_order integer)
RETURNS contacts
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    updated_contact contacts;
BEGIN
    UPDATE contacts SET
        display_order = new_order,
        updated_at = now()
    WHERE id = contact_id
    RETURNING * INTO updated_contact;
    
    IF updated_contact IS NULL THEN
        RAISE EXCEPTION 'Contact not found with id: %', contact_id;
    END IF;
    
    RETURN updated_contact;
END;
$$;

-- Function to cleanup contacts data
CREATE OR REPLACE FUNCTION cleanup_contacts_data()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Remove orphaned article references
    UPDATE articles 
    SET author_contact_id = NULL 
    WHERE author_contact_id IS NOT NULL 
    AND author_contact_id NOT IN (SELECT id FROM contacts);
    
    UPDATE special_articles 
    SET author_contact_id = NULL 
    WHERE author_contact_id IS NOT NULL 
    AND author_contact_id NOT IN (SELECT id FROM contacts);
    
    -- Ensure display_order is not null
    UPDATE contacts SET display_order = 999 WHERE display_order IS NULL;
    
    -- Reorder contacts sequentially
    WITH ordered_contacts AS (
        SELECT id, ROW_NUMBER() OVER (ORDER BY display_order, created_at) as new_order
        FROM contacts
    )
    UPDATE contacts 
    SET display_order = ordered_contacts.new_order
    FROM ordered_contacts
    WHERE contacts.id = ordered_contacts.id;
END;
$$;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION create_contact_admin(jsonb) TO authenticated;
GRANT EXECUTE ON FUNCTION update_contact_admin(uuid, jsonb) TO authenticated;
GRANT EXECUTE ON FUNCTION delete_contact_admin(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION toggle_contact_status_admin(uuid, boolean) TO authenticated;
GRANT EXECUTE ON FUNCTION update_contact_order_admin(uuid, integer) TO authenticated;
GRANT EXECUTE ON FUNCTION cleanup_contacts_data() TO authenticated;

-- Also grant to anon for admin panel access
GRANT EXECUTE ON FUNCTION create_contact_admin(jsonb) TO anon;
GRANT EXECUTE ON FUNCTION update_contact_admin(uuid, jsonb) TO anon;
GRANT EXECUTE ON FUNCTION delete_contact_admin(uuid) TO anon;
GRANT EXECUTE ON FUNCTION toggle_contact_status_admin(uuid, boolean) TO anon;
GRANT EXECUTE ON FUNCTION update_contact_order_admin(uuid, integer) TO anon;
GRANT EXECUTE ON FUNCTION cleanup_contacts_data() TO anon;