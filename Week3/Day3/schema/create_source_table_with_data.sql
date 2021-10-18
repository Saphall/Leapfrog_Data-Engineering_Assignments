-- users
CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  username VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  password TEXT NOT NULL,
  PRIMARY KEY (id)
);

-- administrators
CREATE TABLE IF NOT EXISTS administrators (
  id SERIAL,
  username VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  password TEXT NOT NULL,
  PRIMARY KEY (id)
);


-- categories
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);


-- products
CREATE TABLE IF NOT EXISTS products (
  id SERIAL,
  name VARCHAR(45) NOT NULL,
  price DOUBLE PRECISION NOT NULL,
  quantity INT NULL,
  image VARCHAR(200) NULL,
  image_large VARCHAR(200) NULL,
  category_id INT NULL,
  PRIMARY KEY (id),
  CONSTRAINT category_fk FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- sales
CREATE TABLE IF NOT EXISTS sales (
  id SERIAL,
  user_id INT NOT NULL, 
  product_id INT NOT NULL,
  price DOUBLE PRECISION NOT NULL,
  quantity INT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);





--
INSERT INTO categories (name)
VALUES ('Clothing'),
  ('Electornics'),
  ('Home Appliance');

--
INSERT INTO administrators (username, email, password)
VALUES ('admin', 'admin@admin.com', 'admin@123'),
  ('ram', 'ram@admin.com', 'ram@1010'),
  ('rani', 'rani@admin.com', 'strgpsswrd');

--
INSERT INTO users(username, email, password)
VALUES ('Tushar', 'tushar@gmail.com', 'encpsswrd'),
  ('Kabir', 'kabir_2011@yahoo.com', 'kbr_2011'),
  ('Kundan', 'kd1998@gmail.com', '98dan_pass'),
  ('Praveen', 'coolprv@yahoo.com', 'veen_strg');

--
INSERT INTO products(name, price, quantity, category_id)
VALUES ('Red T-Shirt', 500, 1000, 1),
  ('Green T-Shirt', 550, 800, 1),
  ('Jeans', 2000, 1500, 1),
  ('IPhone 11', 90000, 100, 2),
  ('Sony TV', 100000, 10, 2),
  ('Toaster', 3000, 251, 3),
  ('Vaccum Cleaner', 20000, 505, 3);

--
INSERT INTO sales(user_id, product_id, price, quantity)
VALUES (1, 2, 550, 1),
  (1, 4, 90000, 1),
  (1, 6, 3500, 1),
  (2, 7, 20000, 2),
  (3, 3, 1800, 1),
  (3, 5, 100000, 2),
  (2, 1, 570, 3);
