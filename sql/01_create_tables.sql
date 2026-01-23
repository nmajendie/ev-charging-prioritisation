-- Create lookup table for LAD -> UTLA mapping
DROP TABLE IF EXISTS lad_to_utla;

CREATE TABLE lad_to_utla (
    lad_code TEXT,
    lad_name TEXT,
    utla_code TEXT,
    utla_name TEXT
);