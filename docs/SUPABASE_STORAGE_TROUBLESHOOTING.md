# Supabase Storage Testing - Troubleshooting Guide

## Current Status

✅ **MinIO (Local):** Working perfectly  
⚠️ **Supabase (Production):** Connection issues detected

## Test Results

### MinIO Storage
- ✅ Services running
- ✅ Bucket created and public
- ✅ Ready for use

### Supabase Storage  
- ✅ Bucket created (`nca-videos`)
- ✅ S3 access keys generated
- ✅ Configuration file updated
- ❌ Connection test failing

## Possible Issues

### 1. S3 Protocol Not Enabled
Supabase S3 access might not be enabled by default on all plans.

**Check:** Go to Supabase Dashboard > Storage > Configuration > S3  
**Look for:** Toggle to enable S3 protocol

### 2. Incorrect Access Keys
The access keys might have been copied incorrectly.

**Verify:**
- Access Key ID format: `sbp_...` (starts with `sbp_`)
- Secret Access Key format: `sbp_sk_...` (starts with `sbp_sk_`)

### 3. Bucket Permissions
The bucket might not have the correct RLS policies.

**Check:** Storage > nca-videos > Policies  
**Ensure:** Public read access is enabled

### 4. Endpoint URL Format
The endpoint might need adjustment.

**Current:** `https://pzlfrolcibae3hlicaecdj.supabase.co/storage/v1/s3`  
**Alternative:** Try without `/s3` suffix

## Recommended Next Steps

### Option 1: Verify S3 Access is Enabled
1. Open Supabase Dashboard
2. Go to Storage > Configuration > S3
3. Check if "S3 protocol connection" toggle is ON
4. If OFF, enable it and regenerate access keys

### Option 2: Use Supabase Client Library Instead
Instead of S3 protocol, use Supabase's native storage client:

```python
from supabase import create_client

supabase = create_client(
    "https://pzlfrolcibae3hlicaecdj.supabase.co",
    "your-anon-key"
)

# Upload file
supabase.storage.from_("nca-videos").upload("test.txt", b"Hello")
```

### Option 3: Stick with MinIO for Now
Since MinIO is working perfectly for local development:
- Use MinIO for all development and testing
- Migrate to Supabase/DigitalOcean Spaces later when ready for production

## For Immediate Testing

**Recommendation:** Use MinIO for now since it's fully functional.

```bash
# Use MinIO configuration
docker compose -f docker-compose.local.yml --env-file .env.local.minio up -d
```

## When to Revisit Supabase Storage

- When deploying to production
- When you need cloud storage
- After verifying S3 protocol is enabled in your Supabase plan

## Alternative: DigitalOcean Spaces

If Supabase S3 continues to have issues, consider DigitalOcean Spaces ($5/month):
- Guaranteed S3 compatibility
- 250 GB storage
- 1 TB bandwidth
- CDN included
- Simpler setup

Would you like me to create a DigitalOcean Spaces configuration as well?
