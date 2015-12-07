CREATE DATABASE simply_news;
\c simply_news

CREATE TABLE accounts (id SERIAL PRIMARY KEY, first_name VARCHAR(255), email VARCHAR(255), password_digest VARCHAR(255), date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP);


CREATE TABLE sources (id SERIAL PRIMARY KEY, name VARCHAR(255), rss_url VARCHAR(255), homepage_url VARCHAR(255), image_url VARCHAR(255));

CREATE TABLE account_sources (id SERIAL PRIMARY KEY, fk_account_id INT REFERENCES accounts(id), fk_source_id INT REFERENCES sources(id));

\dt
