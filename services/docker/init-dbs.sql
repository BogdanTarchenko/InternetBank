-- Инициализация БД: по одной базе на сервис (core_db, credit_db)
CREATE USER core WITH PASSWORD 'core';
CREATE DATABASE core_db OWNER core;

CREATE USER credit WITH PASSWORD 'credit';
CREATE DATABASE credit_db OWNER credit;
