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