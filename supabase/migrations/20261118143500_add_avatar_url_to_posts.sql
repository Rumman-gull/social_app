alter table public.posts
  add column if not exists avatar_url text;

notify pgrst, 'reload schema';
