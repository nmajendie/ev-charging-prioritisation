-- ================================================
-- 02_load_lad_to_utla.sql
-- Purpose: Load the LAD -> UTLA lookup CSV into lad_to_utla
-- and rename columns to match project convention.
-- ================================================

-- If the table already exists, drop it
DROP TABLE IF EXISTS lad_to_utla;

-- Create the table (structure must match the CSV columns we care about)
CREATE TABLE lad_to_utla (
    lad_code TEXT,
    lad_name TEXT,
    utla_code TEXT,
    utla_name TEXT
);

-- Optional: If using DB Browser, you can import CSV manually
-- Otherwise, if SQLite CLI supports it:
-- .mode csv
-- .import data/raw/lad_to_utla_lookup.csv lad_to_utla_temp

-- If using a temp table:
-- ALTER TABLE lad_to_utla_temp RENAME COLUMN LAD25CD TO lad_code;
-- ALTER TABLE lad_to_utla_temp RENAME COLUMN LAD25NM TO lad_name;
-- ALTER TABLE lad_to_utla_temp RENAME COLUMN CTYUA25CD TO utla_code;
-- ALTER TABLE lad_to_utla_temp RENAME COLUMN CTYUA25NM TO utla_name;

-- If importing manually in DB Browser, just use this section to
-- rename columns (if necessary) and drop unnecessary ones:

-- Drop columns we don't need (if they exist)
-- ALTER TABLE lad_to_utla DROP COLUMN LAD25NMW;
-- ALTER TABLE lad_to_utla DROP COLUMN CTYUA25NMW;
-- ALTER TABLE lad_to_utla DROP COLUMN ObjectId;

-- After this, lad_to_utla is ready for creating the UTLA view