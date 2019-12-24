# PostgreSQL JSON Scripts
Supported versions: 9.4 - 12

## Functions
Function | Description | Arguments | Returns
--- | --- | --- | ---
traverse_jsonb | Traverses through JSONB node tree | j JSONB | Table: k TEXT (key), v JSONB (value), depth INT, path TEXT[] (all keys up to this key), object BOOLEAN (is this value a JSON object or a leaf node)
jsonb_keys | Retrieves distinct keys in JSONB | j JSONB, show_objects BOOLEAN (defaults to TRUE) | Table: k TEXT (key)
jsonb_paths| Retrieves full key paths in JSONB | j JSONB, show_objects BOOLEAN (defaults to TRUE) | Table: p TEXT[] (path)
jsonb_max_depth | Retrieves maximum depth in JSONB | j JSONB | INT
