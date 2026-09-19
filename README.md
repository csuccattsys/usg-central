# USG Central v3.0

Next.js 15 + React 19 + Tailwind CSS 4 + Supabase foundation for CSU Cabadbaran Campus USG operations.

## Setup
1. Create a Supabase project.
2. Run `supabase/schema.sql` in Supabase SQL Editor.
3. Copy `.env.example` to `.env.local` and add Supabase credentials.
4. Run `npm install`, then `npm run dev`.
5. For Vercel, add the same environment variables.

## Included
Public portal, officer login, dashboard, tasks, activities, meetings, documents, student concerns, announcements, finance, inventory/property, governance, departments, strategic scorecard, users/roles, settings, RLS, and private file storage.

## Scope note
This ZIP is the corrected v3.0 foundation with the Tailwind/PostCSS build issue fixed. The module screens are structured placeholders; live CRUD forms, approvals, exports, notifications, and complete workflow automation are not yet implemented.