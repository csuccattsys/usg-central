create extension if not exists pgcrypto;
create type public.user_role as enum ('super_admin','president','vice_president','executive_secretary','treasurer','auditor','cabinet_secretary','officer','student');
create type public.record_status as enum ('Pending','In Progress','For Review','Approved','Completed','Overdue','Cancelled');

create table public.departments(id uuid primary key default gen_random_uuid(),name text unique not null,description text,head_position text,created_at timestamptz default now());
create table public.profiles(id uuid primary key references auth.users(id) on delete cascade,full_name text not null,student_or_employee_no text,email text,role public.user_role not null default 'student',position text,department_id uuid references public.departments(id),avatar_url text,created_at timestamptz default now());
create table public.tasks(id uuid primary key default gen_random_uuid(),task_no text unique not null,title text not null,description text,assigned_to uuid references public.profiles(id),assigned_department uuid references public.departments(id),due_date date,status public.record_status default 'Pending',created_by uuid references public.profiles(id),created_at timestamptz default now(),completed_at timestamptz);
create table public.activities(id uuid primary key default gen_random_uuid(),activity_no text unique not null,title text not null,description text,lead_department uuid references public.departments(id),event_date date,venue text,budget numeric(14,2) default 0,status text default 'Planning',created_by uuid references public.profiles(id),created_at timestamptz default now());
create table public.documents(id uuid primary key default gen_random_uuid(),document_no text unique not null,document_type text not null,title text not null,status text default 'Draft',author_id uuid references public.profiles(id),file_path text,issued_date date,created_at timestamptz default now());
create table public.meetings(id uuid primary key default gen_random_uuid(),meeting_no text unique not null,title text not null,meeting_date timestamptz not null,venue text,agenda text,minutes text,created_by uuid references public.profiles(id),created_at timestamptz default now());
create table public.student_concerns(id uuid primary key default gen_random_uuid(),tracking_no text unique not null,category text not null,description text not null,submitted_by uuid references public.profiles(id),assigned_to uuid references public.profiles(id),status text default 'New',confidentiality text default 'Restricted',created_at timestamptz default now(),resolved_at timestamptz);
create table public.finance_transactions(id uuid primary key default gen_random_uuid(),reference_no text unique not null,transaction_date date not null,purpose text not null,amount numeric(14,2) not null,transaction_type text not null,status text default 'Pending',created_by uuid references public.profiles(id),created_at timestamptz default now());
create table public.inventory_items(id uuid primary key default gen_random_uuid(),property_no text unique not null,item_name text not null,category text,quantity integer not null default 1,condition text default 'Good',status text default 'Available',location text,custodian_id uuid references public.profiles(id),created_at timestamptz default now());
create table public.borrowing_requests(id uuid primary key default gen_random_uuid(),request_no text unique not null,item_id uuid references public.inventory_items(id),borrower_id uuid references public.profiles(id),purpose text not null,borrowed_at timestamptz,expected_return timestamptz,returned_at timestamptz,return_condition text,status text default 'Pending',approved_by uuid references public.profiles(id),created_at timestamptz default now());
create table public.announcements(id uuid primary key default gen_random_uuid(),title text not null,body text not null,audience text default 'Public',published_at timestamptz,expires_at timestamptz,author_id uuid references public.profiles(id),created_at timestamptz default now());
create table public.scorecard_indicators(id uuid primary key default gen_random_uuid(),objective text not null,indicator text not null,target numeric,actual numeric,unit text default '%',reporting_period text,department_id uuid references public.departments(id),created_at timestamptz default now());
create table public.audit_logs(id uuid primary key default gen_random_uuid(),actor_id uuid references public.profiles(id),action text not null,table_name text,record_id uuid,metadata jsonb,created_at timestamptz default now());

insert into public.departments(name,description,head_position) values
('Office of the Executive Secretary','Executive records, correspondence, meetings, and administrative coordination.','Executive Secretary'),
('Department of Student Welfare and Engagement','Student welfare, concerns, consultation, and engagement.','Cabinet Secretary'),
('Department of Strategic Planning and Performance Management','Strategic plans, scorecards, KPIs, monitoring, and evaluation.','Cabinet Secretary'),
('Department of Finance and Inventory','Budget, financial records, property, inventory, and borrowing.','Treasurer'),
('Department of Multimedia and Creatives','Design, documentation, multimedia, and digital communications.','Cabinet Secretary'),
('Department of External Relations and Partnerships','Partnerships, external coordination, and institutional linkages.','Cabinet Secretary'),
('Department of Academic Affairs','Academic concerns, programs, and student academic engagement.','Cabinet Secretary'),
('Department of Culture, Arts, Sports and Recreation','Culture, arts, sports, recreation, and student activities.','Cabinet Secretary'),
('Department of Environment and Sustainability','Environmental programs and sustainability initiatives.','Cabinet Secretary'),
('Department of Student Services and General Affairs','General student services, requests, and administrative support.','Cabinet Secretary')
on conflict(name) do nothing;

alter table public.departments enable row level security; alter table public.profiles enable row level security; alter table public.tasks enable row level security; alter table public.activities enable row level security; alter table public.documents enable row level security; alter table public.meetings enable row level security; alter table public.student_concerns enable row level security; alter table public.finance_transactions enable row level security; alter table public.inventory_items enable row level security; alter table public.borrowing_requests enable row level security; alter table public.announcements enable row level security; alter table public.scorecard_indicators enable row level security; alter table public.audit_logs enable row level security;

create or replace function public.current_role() returns public.user_role language sql stable security definer set search_path=public as $$ select role from public.profiles where id=auth.uid() $$;
create or replace function public.is_staff() returns boolean language sql stable security definer set search_path=public as $$ select coalesce(public.current_role() <> 'student',false) $$;
create or replace function public.is_finance() returns boolean language sql stable security definer set search_path=public as $$ select coalesce(public.current_role() in ('super_admin','president','treasurer','auditor'),false) $$;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select coalesce(public.current_role() in ('super_admin','president'),false) $$;

create policy "departments authenticated read" on public.departments for select to authenticated using (true);
create policy "profiles own read" on public.profiles for select to authenticated using (id=auth.uid() or public.is_admin());
create policy "tasks staff read" on public.tasks for select to authenticated using (public.is_staff());
create policy "tasks staff write" on public.tasks for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "activities staff read" on public.activities for select to authenticated using (public.is_staff());
create policy "activities staff write" on public.activities for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "documents staff read" on public.documents for select to authenticated using (public.is_staff());
create policy "documents staff write" on public.documents for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "meetings staff read" on public.meetings for select to authenticated using (public.is_staff());
create policy "meetings staff write" on public.meetings for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "concerns staff read" on public.student_concerns for select to authenticated using (public.is_staff() or submitted_by=auth.uid());
create policy "concerns submit" on public.student_concerns for insert to authenticated with check (submitted_by=auth.uid() or public.is_staff());
create policy "concerns staff update" on public.student_concerns for update to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "finance finance read" on public.finance_transactions for select to authenticated using (public.is_finance());
create policy "finance finance write" on public.finance_transactions for all to authenticated using (public.is_finance()) with check (public.is_finance());
create policy "inventory staff read" on public.inventory_items for select to authenticated using (public.is_staff());
create policy "inventory finance write" on public.inventory_items for all to authenticated using (public.is_finance());
create policy "borrowing staff read" on public.borrowing_requests for select to authenticated using (public.is_staff() or borrower_id=auth.uid());
create policy "borrowing staff write" on public.borrowing_requests for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "announcements published public" on public.announcements for select to anon using (published_at is not null and (expires_at is null or expires_at>now()));
create policy "announcements staff read" on public.announcements for select to authenticated using (public.is_staff());
create policy "announcements staff write" on public.announcements for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "scorecard staff read" on public.scorecard_indicators for select to authenticated using (public.is_staff());
create policy "scorecard staff write" on public.scorecard_indicators for all to authenticated using (public.is_staff()) with check (public.is_staff());
create policy "audit admin read" on public.audit_logs for select to authenticated using (public.is_admin());
create policy "audit staff insert" on public.audit_logs for insert to authenticated with check (actor_id=auth.uid());

-- Auth profile trigger
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.profiles(id,full_name,email,role) values(new.id,coalesce(new.raw_user_meta_data->>'full_name','New User'),new.email,'student'); return new; end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

-- Storage bucket for governance/activity files
insert into storage.buckets(id,name,public) values('usg-files','usg-files',false) on conflict(id) do nothing;
create policy "staff upload usg files" on storage.objects for insert to authenticated with check (bucket_id='usg-files' and public.is_staff());
create policy "staff read usg files" on storage.objects for select to authenticated using (bucket_id='usg-files' and public.is_staff());
