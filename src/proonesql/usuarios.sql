-- ===================
-- 1. USERS
-- ===================
INSERT INTO users (u_name, u_mail) VALUES ('Juan Perez', 'juan@mail.com');
INSERT INTO users (u_name, u_mail) VALUES ('Maria Lopez', 'maria@mail.com');
INSERT INTO users (u_name, u_mail) VALUES ('Carlos Sanchez', 'carlos@mail.com');
INSERT INTO users (u_name, u_mail) VALUES ('Ana Martinez', 'ana@mail.com');
INSERT INTO users (u_name, u_mail) VALUES ('Luis Gomez', 'luis@mail.com');

-- ===================
-- 2. CATEGORIES
-- ===================
INSERT INTO categories (cat_name) VALUES ('Tecnología');
INSERT INTO categories (cat_name) VALUES ('Salud');
INSERT INTO categories (cat_name) VALUES ('Educación');
INSERT INTO categories (cat_name) VALUES ('Deportes');
INSERT INTO categories (cat_name) VALUES ('Cultura');

-- ===================
-- 3. TAGS
-- ===================
INSERT INTO tags (tag_name) VALUES ('AI');
INSERT INTO tags (tag_name) VALUES ('COVID');
INSERT INTO tags (tag_name) VALUES ('Python');
INSERT INTO tags (tag_name) VALUES ('Fútbol');
INSERT INTO tags (tag_name) VALUES ('Historia');

-- ===================
-- 4. ARTICLES
-- ===================
-- Suponemos que los usuarios insertados tienen IDs 1,2,3,4,5
INSERT INTO articles (tname, creation_date, user_id, text) 
VALUES ('Primer Artículo', DATE '2025-09-26', 1, 'Contenido del primer artículo.');

INSERT INTO articles (tname, creation_date, user_id, text) 
VALUES ('Segundo Artículo', DATE '2025-09-25', 2, 'Contenido del segundo artículo.');

INSERT INTO articles (tname, creation_date, user_id, text) 
VALUES ('Tercer Artículo', DATE '2025-09-24', 3, 'Contenido del tercer artículo.');

INSERT INTO articles (tname, creation_date, user_id, text) 
VALUES ('Cuarto Artículo', DATE '2025-09-23', 4, 'Contenido del cuarto artículo.');

INSERT INTO articles (tname, creation_date, user_id, text) 
VALUES ('Quinto Artículo', DATE '2025-09-22', 5, 'Contenido del quinto artículo.');

-- ===================
-- 5. COMMENTS
-- ===================
-- Suponemos que los artículos insertados tienen IDs 1,2,3,4,5
INSERT INTO comments (commentary, u_id, url) VALUES ('Muy buen artículo', 2, 1);
INSERT INTO comments (commentary, u_id, url) VALUES ('Interesante lectura', 3, 1);
INSERT INTO comments (commentary, u_id, url) VALUES ('Aprendí mucho', 1, 2);
INSERT INTO comments (commentary, u_id, url) VALUES ('Excelente contenido', 4, 3);
INSERT INTO comments (commentary, u_id, url) VALUES ('Muy informativo', 5, 4);

-- ===================
-- 6. ART_CAT (Relación N-N entre artículos y categorías)
-- ===================
INSERT INTO art_cat (id_art, id_cat) VALUES (1, 1);
INSERT INTO art_cat (id_art, id_cat) VALUES (2, 2);
INSERT INTO art_cat (id_art, id_cat) VALUES (3, 3);
INSERT INTO art_cat (id_art, id_cat) VALUES (4, 4);
INSERT INTO art_cat (id_art, id_cat) VALUES (5, 5);

-- ===================
-- 7. ART_TAG (Relación N-N entre artículos y tags)
-- ===================
INSERT INTO art_tag (id_art, id_tag) VALUES (1, 1);
INSERT INTO art_tag (id_art, id_tag) VALUES (2, 2);
INSERT INTO art_tag (id_art, id_tag) VALUES (3, 3);
INSERT INTO art_tag (id_art, id_tag) VALUES (4, 4);
INSERT INTO art_tag (id_art, id_tag) VALUES (5, 5);

-- ===================
-- COMMIT FINAL
-- ===================
COMMIT;
