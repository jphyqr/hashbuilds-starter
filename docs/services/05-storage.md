# 05-storage.md - File Storage Configuration

<!--
PROMPT: Storage is optional - skip if you don't need file uploads. Ask me:

1. Do you need file uploads for MVP?
   - Yes → Continue
   - Not yet → Skip this file, come back later

2. What types of files will users upload?
   - Profile photos
   - Content images (listings, products)
   - Documents (PDFs, contracts)
   - Media (audio, video)

3. What's your preferred storage provider?
   - Vercel Blob (simplest, good for Vercel projects)
   - Cloudflare R2 (cheapest at scale, no egress fees)
   - AWS S3 (enterprise, full control)
   - Uploadthing (simplest API)

After you answer, I'll help you configure file uploads.
-->

---

## What It Does

Handles file uploads: images, documents, user-generated content.

---

## When You Need It

- **Profile photos** - User avatars
- **Content images** - Blog posts, listings, products
- **Documents** - PDFs, contracts, attachments
- **Media** - Audio, video files

---

## Decision Point

> **Claude Code should ask the developer:**
>
> "Do you need file uploads?"
>
> | Answer | Action |
> |--------|--------|
> | **Yes** | Continue with setup |
> | **Not yet** | Skip this file, come back later |

---

## Decision Point 2

> **Claude Code should ask the developer:**
>
> "What storage provider do you want?"
>
> | Provider | Best For | Pricing |
> |----------|----------|---------|
> | **Vercel Blob** | Simple, Vercel integration | $0.15/GB stored, $0.30/GB transfer |
> | **Cloudflare R2** | Cheap at scale, S3-compatible | $0.015/GB stored, no egress fees |
> | **AWS S3** | Full control, enterprise | $0.023/GB stored + transfer |
> | **Supabase Storage** | If already using Supabase | Included in Supabase plan |
> | **Uploadthing** | Simplest API | 2GB free, then $10/mo |
>
> **Our default recommendation: Vercel Blob**
> - Dead simple with Vercel
> - No bucket configuration
> - Works out of the box

---

## Recommended Setup: Vercel Blob

### Step 1: Enable Blob Storage

1. Go to Vercel Dashboard
2. Select your project
3. Go to Storage tab
4. Click "Create" → "Blob"
5. Copy the token

### Step 2: Add Environment Variable

```env
BLOB_READ_WRITE_TOKEN="vercel_blob_xxx"
```

### Step 3: Install Dependencies

Already included in starter:
```bash
pnpm add @vercel/blob
```

### Step 4: Create Upload Helper

Create `lib/storage.ts`:

```typescript
import { put, del, list } from '@vercel/blob'

export async function uploadFile(file: File, folder?: string) {
  const filename = folder ? `${folder}/${file.name}` : file.name

  const blob = await put(filename, file, {
    access: 'public',
  })

  return blob.url
}

export async function deleteFile(url: string) {
  await del(url)
}

export async function listFiles(prefix?: string) {
  const { blobs } = await list({ prefix })
  return blobs
}
```

### Step 5: Create Upload API Route

Create `app/api/upload/route.ts`:

```typescript
import { put } from '@vercel/blob'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const formData = await request.formData()
  const file = formData.get('file') as File

  if (!file) {
    return NextResponse.json({ error: 'No file provided' }, { status: 400 })
  }

  // Validate file type
  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf']
  if (!allowedTypes.includes(file.type)) {
    return NextResponse.json({ error: 'Invalid file type' }, { status: 400 })
  }

  // Validate file size (10MB max)
  if (file.size > 10 * 1024 * 1024) {
    return NextResponse.json({ error: 'File too large' }, { status: 400 })
  }

  try {
    const blob = await put(file.name, file, {
      access: 'public',
    })

    return NextResponse.json({ url: blob.url })
  } catch (error) {
    return NextResponse.json({ error: String(error) }, { status: 500 })
  }
}
```

---

## Environment Variables

```env
# Vercel Blob
BLOB_READ_WRITE_TOKEN="vercel_blob_xxx"
```

---

## Client-Side Upload Component

```tsx
'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'

export function FileUpload({ onUpload }: { onUpload: (url: string) => void }) {
  const [uploading, setUploading] = useState(false)

  async function handleUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (!file) return

    setUploading(true)

    const formData = new FormData()
    formData.append('file', file)

    try {
      const res = await fetch('/api/upload', {
        method: 'POST',
        body: formData,
      })

      const { url, error } = await res.json()

      if (error) throw new Error(error)

      onUpload(url)
    } catch (error) {
      console.error('Upload failed:', error)
    } finally {
      setUploading(false)
    }
  }

  return (
    <div>
      <input
        type="file"
        onChange={handleUpload}
        disabled={uploading}
        accept="image/*,.pdf"
      />
      {uploading && <span>Uploading...</span>}
    </div>
  )
}
```

---

## Common Patterns

### Store URL in Database

```typescript
// After upload, save URL to database
const imageUrl = await uploadFile(file, 'listings')

await db.listing.update({
  where: { id: listingId },
  data: { imageUrl },
})
```

### Multiple Images

```typescript
// Store as JSON array in database
const imageUrls = await Promise.all(
  files.map(file => uploadFile(file, `listings/${listingId}`))
)

await db.listing.update({
  where: { id: listingId },
  data: { images: imageUrls },  // Prisma Json field
})
```

---

## Common Issues

### "Unauthorized"
- Check BLOB_READ_WRITE_TOKEN is set
- Ensure token has read/write permissions

### "File too large"
- Vercel Blob has 500MB limit
- Implement client-side size check

### "Slow uploads"
- Consider chunked uploads for large files
- Add progress indicator for UX

---

## Status

| Item | Status |
|------|--------|
| Storage needed? | [ ] |
| Provider chosen | [ ] |
| Token configured | [ ] |
| Upload route created | [ ] |
| Upload tested | [ ] |

---

_Last updated: [DATE]_
