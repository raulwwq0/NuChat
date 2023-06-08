UPDATE public.profiles
SET
  username = 'test-' || id::text,
  full_name = 'Test User'
WHERE
    username IS NULL
AND
    full_name IS NULL;