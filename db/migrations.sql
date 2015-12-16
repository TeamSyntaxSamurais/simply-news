CREATE DATABASE simply_news;
use simply_news;

CREATE TABLE accounts (id SERIAL PRIMARY KEY, first_name VARCHAR(255), email VARCHAR(255), password_digest VARCHAR(255), date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE sources (id SERIAL PRIMARY KEY, name VARCHAR(255), rss_url VARCHAR(255), homepage_url VARCHAR(255), image_url VARCHAR(255));

CREATE TABLE account_sources (id SERIAL PRIMARY KEY, account_id INT REFERENCES accounts(id), source_id INT REFERENCES sources(id));

CREATE TABLE categories (id SERIAL PRIMARY KEY, name VARCHAR(255));

CREATE TABLE source_categories (id SERIAL PRIMARY KEY, source_id INT REFERENCES sources(id), category_id INT REFERENCES categories(id));
