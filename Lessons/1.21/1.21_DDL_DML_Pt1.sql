-- .read "Lessons/1.21/1.21_DDL_DML_Pt1.sql"
 USE data_jobs;
 DROP  DATABASE if EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging ;



-- DROP TABLE main.preferred_roles;


CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INTEGER primary key,
    role_name VARCHAR
);
SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

INSERT INTO staging.preferred_roles (role_id,role_name)
    VALUES 
        (1,'Data Engineer'),
        (2,'Senior Data Engineer');

    INSERT INTO staging.preferred_roles (role_id,role_name)
    VALUES 
        (3,'Software Engineer');
  

    ALTER TABLE staging.preferred_roles
    ADD  column preferred_role BOOLEAN ;


     ALTER TABLE staging.preferred_roles
    RENAME COLUMN preferred_role TO priority_lvl;

    ALTER TABLE staging.preferred_roles
    ALTER column priority_lvl TYPE INTEGER ;

    UPDATE staging.preferred_roles
    SET priority_lvl = TRUE
    WHERE role_id = 1 or role_id =2;

      UPDATE staging.preferred_roles
    SET priority_lvl = FALSE
    WHERE role_id = 3;

     
     UPDATE staging.preferred_roles
     SET priority_lvl = 3
     WHERE role_id = 3 OR role_id = 4;

 Select 
    *
 from staging.preferred_roles;