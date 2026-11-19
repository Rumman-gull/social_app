alter table public.posts
  add column if not exists community_id integer
  references public.communities (id) on delete set null;

notify pgrst, 'reload schema';
