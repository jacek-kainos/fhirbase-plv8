--db:fhirb
--{{{
SELECT
count(
eval_ddl(
  eval_template($SQL$
    CREATE TABLE "{{tbl_name}}" (
      version_id uuid PRIMARY KEY,
      logical_id uuid UNIQUE,
      last_modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
      published  TIMESTAMP WITH TIME ZONE NOT NULL,
      data jsonb NOT NULL
    );

    CREATE TABLE "{{tbl_name}}_history" (
      version_id uuid PRIMARY KEY,
      logical_id uuid NOT NULL,
      last_modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
      published  TIMESTAMP WITH TIME ZONE NOT NULL,
      data jsonb NOT NULL
    );

    CREATE TABLE "{{tbl_name}}_search_string" (
      _id SERIAL PRIMARY KEY,
      resource_id uuid references "{{tbl_name}}"(logical_id),
      param varchar NOT NULL,
      value varchar
      -- ts_value ts_vector
    );

    CREATE TABLE "{{tbl_name}}_search_token" (
      _id SERIAL PRIMARY KEY,
      resource_id uuid references "{{tbl_name}}"(logical_id),
      param varchar NOT NULL,
      namespace varchar,
      code varchar,
      text varchar
      -- ts_value ts_vector
    );

    CREATE TABLE "{{tbl_name}}_search_date" (
    _id SERIAL PRIMARY KEY,
    resource_id uuid references "{{tbl_name}}"(logical_id),
    param varchar NOT NULL,
    "start" timestamptz,
    "end" timestamptz
    );

    -- references
    CREATE TABLE "{{tbl_name}}_search_reference" (
    _id SERIAL PRIMARY KEY,
    resource_id uuid references "{{tbl_name}}"(logical_id),
    param varchar NOT NULL,
    resource_type varchar NOT NULL,
    logical_id varchar NOT NULL,
    url varchar
    );

    --quantity
    CREATE TABLE "{{tbl_name}}_search_quantity" (
      _id SERIAL PRIMARY KEY,
      resource_id uuid references "{{tbl_name}}"(logical_id),
      param varchar,
      value decimal,
      comparator varchar,
      units varchar,
      system varchar,
      code varchar
    );

    -- index for search includes
    CREATE TABLE "{{tbl_name}}_references" (
      _id SERIAL PRIMARY KEY,
      logical_id uuid NOT NULL,
      path varchar NOT NULL,
      reference_type varchar NOT NULL,
      reference_id uuid NOT NULL
    );
  $SQL$,
  'tbl_name', lower(path[1]))))
FROM fhir.resource_elements
WHERE array_length(path,1) = 1;
--}}}