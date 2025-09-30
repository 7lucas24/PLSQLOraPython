# PL/SQL con ORACLE y Python

Proyecto del primer parcial

## Getting Started

El objetivo de este proyecto es desarrollar una aplicación en Python que permita administrar un blog en una
base de datos en Oracle, mediante procedimientos y funciones almacenadas en PL/SQL

---

### Prerequisitos

* Conocimientos en bases de datos en Oracle y el lenguaje de programacion Python.

### Creacion del usuario
* CREATE USER proone IDENTIFIED BY abc
* DEFAULT TABLESPACE USERS
* TEMPORARY TABLESPACE TEMP
* QUOTA UNLIMITED ON USERS;
* GRANT RESOURCE TO proone;
* GRANT DBA TO proone;

SELECT username, account_status, lock_date FROM cdb_users WHERE username = 'PROONE';

### Coneccion desde terminal
* docker exec -it oracle-xe sqlplus proone/abc@//localhost/XEPDB1
* sqlplus proone/abc@localhost:abc/XEPDB1;


## Construido con

* **Oracle** - Base de datos
* **Python** - Lenguaje de programacion

---

## Autores

* Luis Arturo Hernández Castillo 
* Isaac Gonzalez Aguilera

---

## Agradecimientos

* A los profesores de la UACH por guiar el aprendizaje del desarrollo de software.
* A quienes contribuyeron con documentación y ejemplos de metodologías.