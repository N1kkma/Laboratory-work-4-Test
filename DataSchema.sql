CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_email CHECK (email LIKE '%_@__%.__%')
);

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    loc_name VARCHAR(100) NOT NULL,
    arch_style VARCHAR(50) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    description VARCHAR(500)
);

CREATE TABLE routes (
    route_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    route_name VARCHAR(100) NOT NULL,
    safety_score INTEGER DEFAULT 0,
    is_clean_air BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_routes_user
        FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT chk_routes_safety
        CHECK (safety_score BETWEEN 0 AND 100)
);

CREATE TABLE route_locations (
    route_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    order_seq INTEGER NOT NULL,
    CONSTRAINT pk_route_locations
        PRIMARY KEY (route_id, location_id),
    CONSTRAINT fk_rl_route
        FOREIGN KEY (route_id) REFERENCES routes (route_id),
    CONSTRAINT fk_rl_location
        FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE friend_requests (
    request_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fr_sender
        FOREIGN KEY (sender_id) REFERENCES users (user_id),
    CONSTRAINT fk_fr_receiver
        FOREIGN KEY (receiver_id) REFERENCES users (user_id),
    CONSTRAINT chk_fr_status
        CHECK (status IN ('pending', 'accepted', 'rejected')),
    CONSTRAINT chk_fr_diff_users
        CHECK (sender_id != receiver_id)
);

