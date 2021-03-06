ALTER SESSION SET CONTAINER=MYCONTAINER;

-- Create user
DEFINE user = myschema
DEFINE passwd = myschema

CREATE USER &user IDENTIFIED BY &passwd;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO &user;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE TO &user;