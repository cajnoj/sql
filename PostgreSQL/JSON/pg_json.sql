CREATE OR REPLACE FUNCTION traverse_jsonb (j JSONB)
RETURNS TABLE (k TEXT, v JSONB, depth INT, path TEXT[], object BOOLEAN)
LANGUAGE SQL AS $foo$
WITH RECURSIVE jtree(k, v, depth, path, object) AS (
    SELECT k, v, 1, ARRAY[k], JSONB_TYPEOF(v) = 'object'
    FROM JSONB_EACH(j) AS t(k, v)
    UNION ALL
    SELECT t.k, t.v, depth+1, path||t.k, JSONB_TYPEOF(t.v) = 'object'
    FROM jtree jt, JSONB_EACH(jt.v) AS t(k, v)
    WHERE JSONB_TYPEOF(jt.v) = 'object'
)
SELECT *
FROM jtree
ORDER BY path;
$foo$;

CREATE OR REPLACE FUNCTION jsonb_keys (j JSONB, show_objects BOOLEAN DEFAULT TRUE)
RETURNS TABLE (k TEXT)
LANGUAGE SQL AS $foo$
SELECT DISTINCT k
FROM traverse_jsonb(j)
WHERE show_objects OR "object" = FALSE;
$foo$;

CREATE OR REPLACE FUNCTION jsonb_paths (j JSONB, show_objects BOOLEAN DEFAULT TRUE)
RETURNS TABLE (p TEXT[])
LANGUAGE SQL AS $foo$
SELECT path
FROM traverse_jsonb(j)
WHERE show_objects OR "object" = FALSE;
$foo$;

CREATE OR REPLACE FUNCTION jsonb_max_depth (j JSONB)
RETURNS INT
LANGUAGE SQL AS $foo$
SELECT COALESCE(MAX(depth), 0)
FROM traverse_jsonb(j);
$foo$;