PRAGMA foreign_keys = ON;

CREATE TABLE user (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    profile_picture TEXT,
    tag TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE videos (
    video_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    view_count INTEGER NOT NULL DEFAULT 0 CHECK (view_count >= 0),
    description TEXT,
    video_data TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE playlist (
    playlist_id INTEGER PRIMARY KEY,
    video_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    privacy TEXT NOT NULL CHECK (privacy IN ('public', 'unlisted', 'private')),
    "order" INTEGER NOT NULL CHECK ("order" >= 1),
    UNIQUE (playlist_id, video_id),
    FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

CREATE TABLE playlist_user (
    playlist_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (playlist_id, user_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    video_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, video_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

CREATE TABLE subscribed (
    subscriber_id INTEGER NOT NULL,
    channel_id INTEGER NOT NULL,
    PRIMARY KEY (subscriber_id, channel_id),
    CHECK (subscriber_id <> channel_id),
    FOREIGN KEY (subscriber_id) REFERENCES user(user_id),
    FOREIGN KEY (channel_id) REFERENCES user(user_id)
);

CREATE TABLE comment (
    comment_id INTEGER PRIMARY KEY,
    video_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    reply_id INTEGER,
    comment_text TEXT NOT NULL,
    pinned INTEGER NOT NULL DEFAULT 0 CHECK (pinned IN (0, 1)),
    FOREIGN KEY (video_id) REFERENCES videos(video_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (reply_id) REFERENCES comment(comment_id)
);

CREATE TABLE bank (
    bank_id INTEGER PRIMARY KEY,
    routing_number TEXT NOT NULL UNIQUE,
    account_number TEXT NOT NULL UNIQUE
);

-- The source diagram spells this table "monitized"; the implementation keeps
-- that name so the database matches the submitted schema exactly.
CREATE TABLE monitized (
    user_id INTEGER PRIMARY KEY,
    bank_id INTEGER NOT NULL UNIQUE,
    verified INTEGER NOT NULL DEFAULT 0 CHECK (verified IN (0, 1)),
    ad_preference TEXT NOT NULL CHECK (ad_preference IN ('enabled', 'disabled')),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (bank_id) REFERENCES bank(bank_id)
);

CREATE TABLE payment (
    payment_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    amount NUMERIC NOT NULL CHECK (amount >= 0),
    time TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE INDEX idx_videos_user_id ON videos(user_id);
CREATE INDEX idx_comments_video_id ON comment(video_id);
CREATE INDEX idx_comments_user_id ON comment(user_id);
CREATE INDEX idx_playlist_user_user_id ON playlist_user(user_id);
CREATE INDEX idx_subscribed_channel_id ON subscribed(channel_id);
CREATE INDEX idx_payment_user_id ON payment(user_id);
