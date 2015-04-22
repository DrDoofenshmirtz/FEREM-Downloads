create role deinc 
  login
  password 'dunkeldorf'
  superuser inherit createdb nocreaterole noreplication;

create database ferem
  with owner            = deinc
       encoding         = 'UTF8'
       tablespace       = pg_default
       lc_collate       = 'en_US.UTF-8'
       lc_ctype         = 'en_US.UTF-8'
       connection limit = -1;

