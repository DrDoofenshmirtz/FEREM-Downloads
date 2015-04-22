-- Assuming you've opened a shell in this file's directory, you can create the
-- database for the FEREM Downloads application by executing
--
--   psql -U postgres -f create-database.sql
--
-- on the command line.

-- Create the role to be used as owner of our database.
create role deinc 
  login
  password 'dunkeldorf'
  superuser inherit createdb nocreaterole noreplication;

-- Create the database to be used for FEREM Downloads.  
create database ferem
  with owner            = deinc
       encoding         = 'UTF8'
       tablespace       = pg_default
       lc_collate       = 'en_US.UTF-8'
       lc_ctype         = 'en_US.UTF-8'
       connection limit = -1;

