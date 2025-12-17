-- Create Supabase Storage Bucket for NCA Videos
-- Run this in your Supabase SQL Editor

-- 1. Create the bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'nca-videos',
  'nca-videos',
  true,  -- Public bucket for video sharing
  524288000,  -- 500MB file size limit
  ARRAY['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/webm']
)
ON CONFLICT (id) DO NOTHING;

-- 2. Create policy for public read access
CREATE POLICY IF NOT EXISTS "Public Access for nca-videos"
ON storage.objects FOR SELECT
USING (bucket_id = 'nca-videos');

-- 3. Create policy for authenticated uploads
CREATE POLICY IF NOT EXISTS "Authenticated Uploads for nca-videos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'nca-videos');

-- 4. Create policy for authenticated updates
CREATE POLICY IF NOT EXISTS "Authenticated Updates for nca-videos"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'nca-videos')
WITH CHECK (bucket_id = 'nca-videos');

-- 5. Create policy for service role deletes
CREATE POLICY IF NOT EXISTS "Service Role Deletes for nca-videos"
ON storage.objects FOR DELETE
TO service_role
USING (bucket_id = 'nca-videos');

-- Verify bucket creation
SELECT * FROM storage.buckets WHERE id = 'nca-videos';
