-- Supabase Dashboard > SQL Editor에서 이 파일 전체를 한 번 실행하세요.
-- 사진은 로그인하지 않아도 볼 수 있고, 윤성/지후 계정만 올릴 수 있습니다.

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'couple-photos',
  'couple-photos',
  true,
  15728640,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'image/heic',
    'image/heif'
  ]
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Anyone can view couple photos" on storage.objects;
create policy "Anyone can view couple photos"
on storage.objects
for select
to anon, authenticated
using (bucket_id = 'couple-photos');

drop policy if exists "Couple can upload photos" on storage.objects;
create policy "Couple can upload photos"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'couple-photos'
  and auth.uid() in (
    'ba25b89b-dcc1-47d6-ba21-1c121f2d23db'::uuid,
    'a0841ad0-435e-4d48-a667-735ea33a5a17'::uuid
  )
);

drop policy if exists "Couple can update main photo" on storage.objects;
create policy "Couple can update main photo"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'couple-photos'
  and auth.uid() in (
    'ba25b89b-dcc1-47d6-ba21-1c121f2d23db'::uuid,
    'a0841ad0-435e-4d48-a667-735ea33a5a17'::uuid
  )
)
with check (
  bucket_id = 'couple-photos'
  and auth.uid() in (
    'ba25b89b-dcc1-47d6-ba21-1c121f2d23db'::uuid,
    'a0841ad0-435e-4d48-a667-735ea33a5a17'::uuid
  )
);
