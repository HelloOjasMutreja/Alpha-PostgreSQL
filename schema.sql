DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_status_history;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email       TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE addresses (
    id           INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id      INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    line         TEXT NOT NULL,
    city         TEXT NOT NULL,
    postal_code  TEXT NOT NULL
);

CREATE TABLE products (
    id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name   TEXT NOT NULL,
    price  NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock  INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE orders (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id     INT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    address_id  INT NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
    status      TEXT NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending','paid','packed','shipped','delivered','cancelled')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE order_items (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id  INT NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity    INT NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, product_id)
);

CREATE TABLE order_status_history (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    old_status  TEXT CHECK (old_status IN ('pending','paid','packed','shipped','delivered','cancelled')),
    new_status  TEXT NOT NULL CHECK (new_status IN ('pending','paid','packed','shipped','delivered','cancelled')),
    changed_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE payments (
    id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id  INT NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    amount    NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    method    TEXT NOT NULL CHECK (method IN ('card','upi','netbanking','cod')),
    paid_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);