# USG Central 2.0

A full-stack-ready University Student Government Operations and Student Services Portal.

## Modules
Public Portal · Officer Dashboard · Tasks · Activities · Meetings · Documents · Student Concerns · Announcements · Finance · Inventory & Borrowing · Governance Registry · Departments · Strategic Scorecard · Users & Roles · Settings.

## Stack
Next.js 15 · TypeScript · Tailwind CSS · Lucide · Supabase Auth/PostgreSQL/Storage · Vercel-ready.

## Setup
1. Install Node.js 20+.
2. `npm install`
3. Copy `.env.example` to `.env.local`.
4. Add Supabase URL and anon key.
5. Run `supabase/schema.sql` in Supabase SQL Editor.
6. `npm run dev`
7. Open `http://localhost:3000`.

## Production checklist
- Create officer accounts in Supabase Auth.
- Change the assigned profile roles from `student` to the authorized USG roles.
- Review every RLS policy against the university's approved governance and privacy rules.
- Configure email/password or approved institutional SSO.
- Configure file retention and backups.
- Add real CRUD forms and server actions for each module.
- Add PDF generation, notifications, audit logging hooks, and reporting exports.
- Never place private student concerns, financial records, or credentials in public storage.

## Governance model represented
The system supports the USG structure with an Executive Secretary, Treasurer, Auditor, seven Cabinet Secretary role slots, departmental workspaces, and the planned ten executive departments. Multiple departments can be supervised by one Cabinet Secretary.
