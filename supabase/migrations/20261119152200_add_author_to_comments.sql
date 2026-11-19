alter table public.comments
  add column if not exists author text;

update public.comments
set author = 'Anonymous'
where author is null;

alter table public.comments
  alter column author set default 'Anonymous',
  alter column author set not null;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'comments'
      and column_name = 'auther'
  ) then
    update public.comments
    set author = auther
    where auther is not null
      and (author is null or author = 'Anonymous');

    update public.comments
    set auther = 'Anonymous'
    where auther is null;

    alter table public.comments
      alter column auther set default 'Anonymous',
      alter column auther set not null;
  end if;
end
$$;

notify pgrst, 'reload schema';
