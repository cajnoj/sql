/*
MIT License

Copyright (c) 2018 cajnoj

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

-- Recursively retrieve all keys and values from JSONB
-- k        - key name
-- v        - value
-- depth    - depth of key in JSONB
-- path     - key names path from top
-- object   - is current value a JSON object or a leaf node

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
