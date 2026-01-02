# UI Patterns

Cross-cutting UI patterns for forms, toasts, errors, loading states, etc.

**These are the default patterns. Use these unless there's a good reason not to.**

---

## Forms

### Standard Form Pattern

Uses: `react-hook-form` + `zod` + shadcn `Form` components

```tsx
'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'

// 1. Define schema
const formSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email'),
})

type FormValues = z.infer<typeof formSchema>

// 2. Component
export function ExampleForm() {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      email: '',
    },
  })

  const onSubmit = async (data: FormValues) => {
    try {
      // API call here
      await createUser(data)
      toast.success('User created!')
      form.reset()
    } catch (error) {
      toast.error('Failed to create user')
    }
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Name</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <Button type="submit" disabled={form.formState.isSubmitting}>
          {form.formState.isSubmitting ? 'Saving...' : 'Save'}
        </Button>
      </form>
    </Form>
  )
}
```

### Server Action Form Pattern

For simpler forms without client-side validation:

```tsx
// actions.ts
'use server'

import { revalidatePath } from 'next/cache'

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string
  const email = formData.get('email') as string

  // Validate
  if (!name || !email) {
    return { error: 'All fields required' }
  }

  // Create
  await db.user.create({ data: { name, email } })

  revalidatePath('/users')
  return { success: true }
}

// Form component
'use client'

import { useActionState } from 'react'
import { createUser } from './actions'

export function SimpleForm() {
  const [state, action, pending] = useActionState(createUser, null)

  return (
    <form action={action}>
      <input name="name" required />
      <input name="email" type="email" required />
      {state?.error && <p className="text-red-500">{state.error}</p>}
      <button disabled={pending}>
        {pending ? 'Saving...' : 'Save'}
      </button>
    </form>
  )
}
```

---

## Toast Notifications

### Setup

Using Sonner (shadcn toast):

```tsx
// app/layout.tsx
import { Toaster } from 'sonner'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Toaster richColors position="top-right" />
      </body>
    </html>
  )
}
```

### Usage Patterns

```tsx
import { toast } from 'sonner'

// Success
toast.success('User created successfully')

// Error
toast.error('Failed to create user')

// With description
toast.success('User created', {
  description: 'They will receive a welcome email',
})

// Loading → Success/Error
const toastId = toast.loading('Creating user...')
try {
  await createUser()
  toast.success('User created', { id: toastId })
} catch {
  toast.error('Failed', { id: toastId })
}

// With action
toast('User deleted', {
  action: {
    label: 'Undo',
    onClick: () => restoreUser(),
  },
})

// Promise (auto loading → success/error)
toast.promise(createUser(), {
  loading: 'Creating...',
  success: 'Created!',
  error: 'Failed',
})
```

### Toast Guidelines

| Scenario | Type | Message Style |
|----------|------|---------------|
| Action completed | `success` | Past tense: "User created" |
| Action failed | `error` | What went wrong: "Failed to create user" |
| Warning | `warning` | What might happen: "This cannot be undone" |
| Info | `info` | Neutral info: "Email sent" |

---

## Error Handling

### Client-Side Error Boundary

```tsx
// app/error.tsx
'use client'

import { useEffect } from 'react'
import { Button } from '@/components/ui/button'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    // Log to error reporting service
    console.error(error)
  }, [error])

  return (
    <div className="flex flex-col items-center justify-center min-h-[400px] gap-4">
      <h2 className="text-xl font-semibold">Something went wrong</h2>
      <p className="text-muted-foreground">
        We're sorry, but something unexpected happened.
      </p>
      <Button onClick={reset}>Try again</Button>
    </div>
  )
}
```

### API Error Handling

```tsx
// lib/api.ts
export async function fetcher<T>(url: string): Promise<T> {
  const res = await fetch(url)

  if (!res.ok) {
    const error = await res.json().catch(() => ({}))
    throw new Error(error.message || 'API request failed')
  }

  return res.json()
}

// Usage with toast
async function handleSubmit() {
  try {
    await fetcher('/api/users')
    toast.success('Success!')
  } catch (error) {
    toast.error(error instanceof Error ? error.message : 'Something went wrong')
  }
}
```

### Form Validation Errors

```tsx
// Display inline with FormMessage (see Forms section above)
<FormMessage />  // Auto-shows validation errors

// Or manually
{form.formState.errors.email && (
  <p className="text-sm text-red-500">
    {form.formState.errors.email.message}
  </p>
)}
```

---

## Loading States

### Button Loading

```tsx
<Button disabled={isLoading}>
  {isLoading ? (
    <>
      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
      Saving...
    </>
  ) : (
    'Save'
  )}
</Button>
```

### Skeleton Loading

```tsx
import { Skeleton } from '@/components/ui/skeleton'

// Card skeleton
function CardSkeleton() {
  return (
    <div className="space-y-3">
      <Skeleton className="h-[200px] w-full rounded-lg" />
      <Skeleton className="h-4 w-3/4" />
      <Skeleton className="h-4 w-1/2" />
    </div>
  )
}

// Use in loading.tsx
export default function Loading() {
  return (
    <div className="grid grid-cols-3 gap-4">
      {Array.from({ length: 6 }).map((_, i) => (
        <CardSkeleton key={i} />
      ))}
    </div>
  )
}
```

### Suspense Fallback

```tsx
import { Suspense } from 'react'

export default function Page() {
  return (
    <Suspense fallback={<CardSkeleton />}>
      <AsyncComponent />
    </Suspense>
  )
}
```

---

## Empty States

```tsx
// components/shared/EmptyState.tsx
import { Button } from '@/components/ui/button'

type EmptyStateProps = {
  icon?: React.ReactNode
  title: string
  description: string
  action?: {
    label: string
    onClick: () => void
  }
}

export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-12 text-center">
      {icon && <div className="mb-4 text-muted-foreground">{icon}</div>}
      <h3 className="text-lg font-medium">{title}</h3>
      <p className="mt-1 text-sm text-muted-foreground max-w-sm">
        {description}
      </p>
      {action && (
        <Button onClick={action.onClick} className="mt-4">
          {action.label}
        </Button>
      )}
    </div>
  )
}

// Usage
<EmptyState
  icon={<InboxIcon className="h-12 w-12" />}
  title="No listings yet"
  description="Create your first listing to get started"
  action={{
    label: 'Create listing',
    onClick: () => setDialogOpen(true)
  }}
/>
```

---

## Confirmation Dialogs

```tsx
// components/shared/ConfirmDialog.tsx
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'

type ConfirmDialogProps = {
  open: boolean
  onOpenChange: (open: boolean) => void
  title: string
  description: string
  confirmLabel?: string
  cancelLabel?: string
  onConfirm: () => void
  destructive?: boolean
}

export function ConfirmDialog({
  open,
  onOpenChange,
  title,
  description,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  onConfirm,
  destructive = false,
}: ConfirmDialogProps) {
  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>{title}</AlertDialogTitle>
          <AlertDialogDescription>{description}</AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>{cancelLabel}</AlertDialogCancel>
          <AlertDialogAction
            onClick={onConfirm}
            className={destructive ? 'bg-red-600 hover:bg-red-700' : ''}
          >
            {confirmLabel}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}

// Usage
const [showConfirm, setShowConfirm] = useState(false)

<ConfirmDialog
  open={showConfirm}
  onOpenChange={setShowConfirm}
  title="Delete listing?"
  description="This action cannot be undone."
  confirmLabel="Delete"
  onConfirm={handleDelete}
  destructive
/>
```

---

## Pattern Registry

When you establish a new pattern, add it here:

| Pattern | Location | Description |
|---------|----------|-------------|
| Forms | This file | react-hook-form + zod + shadcn |
| Toasts | This file | Sonner with richColors |
| Errors | This file | Error boundary + toast fallback |
| Loading | This file | Skeleton + Suspense |

---

_If you introduce a better pattern, update this file so future features use it consistently._
