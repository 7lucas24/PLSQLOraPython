--Constraints de Users
--Solo se agrega primary key y email uniique
ALTER TABLE users ADD CONSTRAINT usr_id_pk PRIMARY KEY (u_id);
ALTER TABLE users ADD CONSTRAINT usr_mail_uu UNIQUE (u_mail);

--Constraints de articles, solo se agregaron el id como llave primaria
--titulo unico para los articulos y el foregin key de users
--users 1 to N articles
ALTER TABLE articles ADD CONSTRAINT artpk PRIMARY KEY (article_id);
ALTER TABLE articles ADD CONSTRAINT articles_title UNIQUE (tname);
ALTER TABLE articles ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(u_id);

--Constraints de categories, solo se agregaron el id como llave primaria
--titulo unico para las categorias 
--categories N to N articles
ALTER TABLE categories ADD CONSTRAINT cat_pk PRIMARY KEY (cat_id);
ALTER TABLE categories ADD CONSTRAINT cat_n_uu UNIQUE (cat_name);

--Constraints de tags, solo se agregaron el id como llave primaria
--titulo unico para los tags 
--tags N to N articles
ALTER TABLE tags ADD CONSTRAINT catpk PRIMARY KEY (tag_id);
ALTER TABLE tags ADD CONSTRAINT tag_n_uu UNIQUE (tag_name);

-- Constraints de comments
-- Solo se agrega primary key y foregin key con users
-- Pero limitamos a que los usuarios solo dejen un comentario
--users 1 to N comments || articles 1 to N comments
ALTER TABLE comments ADD CONSTRAINT compk PRIMARY KEY (com_id);
ALTER TABLE comments ADD CONSTRAINT usr_id_fk FOREIGN KEY (u_id) REFERENCES users(u_id);
ALTER TABLE comments ADD CONSTRAINT art_id_fk FOREIGN KEY (url) REFERENCES articles(article_id);


--Constraints de art_cat y de art_tag, tablas intermedias n-n
-- entre articles-categories y articles tags
ALTER TABLE art_cat ADD CONSTRAINT art_cat_id_fk FOREIGN KEY (id_art) REFERENCES articles(article_id);
ALTER TABLE art_cat ADD CONSTRAINT categories_id_fk FOREIGN KEY (id_cat) REFERENCES categories(cat_id);
ALTER TABLE art_cat ADD CONSTRAINT acpk PRIMARY KEY(id_art, id_cat);

ALTER TABLE art_tag ADD CONSTRAINT art_tag_id_fk FOREIGN KEY (id_art) REFERENCES articles(article_id);
ALTER TABLE art_tag ADD CONSTRAINT tags_id_fk FOREIGN KEY (id_tag) REFERENCES tags(tag_id);
ALTER TABLE art_tag ADD CONSTRAINT atpk PRIMARY KEY (id_art, id_tag);
