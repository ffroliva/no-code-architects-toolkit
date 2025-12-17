# NCA Toolkit Storage Configuration Guide

## Overview
The NCA Toolkit supports dual storage configuration:
- **MinIO** for local development
- **Supabase Storage** for production

Both use S3-compatible APIs, making it easy to switch between environments.

---

## MinIO Setup (Local Development)

### 1. Start Services
```bash
cd c:\development\github\compiled-growth\nca
docker compose -f docker-compose.local.yml up -d
```

### 2. Verify MinIO
- **Console:** http://localhost:9001
- **API:** http://localhost:9000
- **Credentials:** minioadmin / minioadmin123

### 3. Bucket Configuration
**Bucket Name:** `nca-videos`
**Access Policy:** Public download (read-only)

**Status:** ✅ Created and configured

### 4. Test Access
```bash
# List buckets
docker exec nca-minio mc ls local/

# Check bucket policy
docker exec nca-minio mc anonymous get local/nca-videos
```

### 5. Environment Configuration
Use `.env.local.minio` for local development:
```bash
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin123
S3_BUCKET=nca-videos
```

---

## Supabase Storage Setup (Production)

### 1. Access Supabase Dashboard
Navigate to your Supabase project dashboard

### 2. Create Storage Bucket

**Option A: Via Dashboard**
1. Go to **Storage** section
2. Click **New bucket**
3. Name: `nca-videos`
4. Set to **Public** bucket
5. Click **Create bucket**

**Option B: Via SQL**
```sql
-- Create the bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('nca-videos', 'nca-videos', true);

-- Set public access policy
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'nca-videos');

-- Allow authenticated uploads
CREATE POLICY "Authenticated Uploads"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'nca-videos' AND auth.role() = 'authenticated');
```

### 3. Get S3 Credentials
1. Go to **Project Settings** > **API**
2. Scroll to **S3 Access Keys**
3. Click **Generate new key**
4. Save the Access Key ID and Secret Access Key

### 4. Configure Environment
Update `.env.supabase.example` with your credentials:
```bash
S3_ENDPOINT=https://YOUR_PROJECT_REF.supabase.co/storage/v1/s3
S3_ACCESS_KEY=YOUR_ACCESS_KEY_ID
S3_SECRET_KEY=YOUR_SECRET_ACCESS_KEY
S3_BUCKET=nca-videos
USE_SSL=true
```

### 5. Test Connection
```bash
# Using AWS CLI
aws s3 ls s3://nca-videos \
  --endpoint-url https://YOUR_PROJECT_REF.supabase.co/storage/v1/s3 \
  --region us-east-1
```

---

## Switching Between Environments

### Local Development
```bash
cp .env.local.minio .env
docker compose -f docker-compose.local.yml up -d
```

### Production
```bash
cp .env.supabase .env
# Deploy to your production environment
```

---

## Bucket Permissions

### MinIO (Local)
- **Read:** Public (anyone can download)
- **Write:** Authenticated via API key

### Supabase (Production)
- **Read:** Public (anyone can download)
- **Write:** Authenticated users only
- **Delete:** Service role only

---

## Testing Both Storage Solutions

### Test MinIO
```bash
# Upload test file
curl -X POST http://localhost:8080/api/v1/test-upload \
  -H "X-API-Key: local-dev-api-key-12345" \
  -F "file=@test-video.mp4"

# Verify in MinIO Console
open http://localhost:9001/buckets/nca-videos/browse
```

### Test Supabase
```bash
# Upload test file (production)
curl -X POST https://your-api.com/api/v1/test-upload \
  -H "X-API-Key: your-production-key" \
  -F "file=@test-video.mp4"

# Verify in Supabase Dashboard
# Go to Storage > nca-videos
```

---

## Troubleshooting

### MinIO Issues
- **Port 9000 in use:** Stop other MinIO instances
- **Bucket not found:** Recreate via console or mc command
- **Permission denied:** Check bucket policy is set to public

### Supabase Issues
- **S3 credentials not working:** Regenerate keys in dashboard
- **Bucket not accessible:** Verify bucket is set to public
- **Upload fails:** Check RLS policies allow authenticated uploads

---

## Integration with n8n

Both storage solutions can be accessed from n8n workflows:

### MinIO (from n8n container)
```javascript
// Use host.docker.internal or MinIO container name
const endpoint = 'http://host.docker.internal:9000';
const bucket = 'nca-videos';
```

### Supabase (from n8n)
```javascript
// Use Supabase Storage node or HTTP Request
const endpoint = 'https://YOUR_PROJECT_REF.supabase.co/storage/v1';
const bucket = 'nca-videos';
```

---

## Next Steps

1. ✅ MinIO bucket created and configured
2. ⏳ Create Supabase storage bucket
3. ⏳ Test both storage solutions
4. ⏳ Configure n8n workflows to use storage
5. ⏳ Fix Supabase container restart issues
