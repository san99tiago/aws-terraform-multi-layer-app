---------------------------------------
-- BOOTSTRAP THE DATABASE AND TABLES--
---------------------------------------

-- CREATE THE DATABASE MOVIE_DB INSIDE SCHEMA --
CREATE DATABASE `movie_db`;

-- CREATE THE PUBLICATIONS TABLE --
CREATE TABLE `movie_db`.`publications` (
  `name` VARCHAR(250) NOT NULL,
  `avatar` VARCHAR(250) NULL,
  PRIMARY KEY (`name`));

-- CREATE THE REVIEWERS TABLE --
CREATE TABLE `movie_db`.`reviewers` (
  `name` VARCHAR(250) NOT NULL,
  `publication` VARCHAR(250) NULL,
  `avatar` VARCHAR(250) NULL,
  PRIMARY KEY (`name`));

-- CREATE THE MOVIES TABLE --
CREATE TABLE `movie_db`.`movies` (
  `title` VARCHAR(250) NOT NULL,
  `release_year` VARCHAR(250) NULL,
  `score` INT NULL,
  `reviewer` VARCHAR(250) NULL,
  `publication` VARCHAR(250) NULL,
  PRIMARY KEY (`title`));
