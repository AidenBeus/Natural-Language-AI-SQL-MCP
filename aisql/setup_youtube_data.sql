INSERT INTO user (user_id, username, password, profile_picture, tag, email) VALUES
    (1, 'TechTales', 'demo_hash_1', 'https://img.example/techtales.png', '@techtales', 'techtales@example.com'),
    (2, 'MayaMakes', 'demo_hash_2', 'https://img.example/maya.png', '@mayamakes', 'maya@example.com'),
    (3, 'PixelPete', 'demo_hash_3', 'https://img.example/pete.png', '@pixelpete', 'pete@example.com'),
    (4, 'DataDuo', 'demo_hash_4', 'https://img.example/dataduo.png', '@dataduo', 'duo@example.com'),
    (5, 'AvaWatches', 'demo_hash_5', 'https://img.example/ava.png', '@avawatches', 'ava@example.com');

INSERT INTO videos (video_id, title, view_count, description, video_data, user_id) VALUES
    (1, 'SQLite in 10 Minutes', 18200, 'A practical introduction to SQLite.', 'videos/sqlite-10.mp4', 1),
    (2, 'Building a Mechanical Keyboard', 26750, 'Choosing switches, cases, and keycaps.', 'videos/keyboard.mp4', 2),
    (3, 'Python Data Cleanup Tips', 10400, 'Three repeatable cleanup patterns.', 'videos/data-cleanup.mp4', 4),
    (4, 'Desk Setup Tour', 8300, 'A compact creator workspace.', 'videos/desk-tour.mp4', 2),
    (5, 'Understanding SQL Joins', 22100, 'Visual explanation of common joins.', 'videos/sql-joins.mp4', 1);

INSERT INTO playlist (playlist_id, video_id, name, privacy, "order") VALUES
    (1, 1, 'SQL Fundamentals', 'public', 1),
    (2, 2, 'Maker Projects', 'public', 1),
    (3, 5, 'SQL Fundamentals: Joins', 'public', 2),
    (4, 4, 'Maker Projects: Workspace', 'public', 2),
    (5, 3, 'Data Skills', 'unlisted', 1);

INSERT INTO playlist_user (playlist_id, user_id) VALUES
    (1, 1), (2, 2), (3, 1), (4, 2), (5, 4), (1, 5);

INSERT INTO likes (user_id, video_id) VALUES
    (2, 1), (3, 1), (5, 1), (1, 2), (3, 2), (5, 2),
    (1, 3), (2, 3), (5, 3), (1, 5), (2, 5), (4, 5);

INSERT INTO subscribed (subscriber_id, channel_id) VALUES
    (2, 1), (3, 1), (5, 1), (1, 2), (3, 2), (5, 2), (1, 4), (2, 4);

INSERT INTO comment (comment_id, video_id, user_id, reply_id, comment_text, pinned) VALUES
    (1, 1, 2, NULL, 'The join explanation was especially helpful.', 1),
    (2, 1, 1, 1, 'Glad it helped!', 0),
    (3, 2, 5, NULL, 'Which switches did you choose?', 0),
    (4, 2, 2, 3, 'Linear switches for this build.', 0),
    (5, 3, 1, NULL, 'Great examples for a data project.', 0),
    (6, 5, 4, NULL, 'This should be required viewing.', 1);

INSERT INTO bank (bank_id, routing_number, account_number) VALUES
    (1, '021000021', '000123456789'),
    (2, '111000025', '000987654321'),
    (3, '322271627', '000456789123');

INSERT INTO monitized (user_id, bank_id, verified, ad_preference) VALUES
    (1, 1, 1, 'enabled'),
    (2, 2, 1, 'enabled'),
    (4, 3, 0, 'disabled');

INSERT INTO payment (payment_id, user_id, amount, time) VALUES
    (1, 1, 143.27, '2026-09-01T12:00:00Z'),
    (2, 2, 208.14, '2026-09-01T12:00:00Z'),
    (3, 1, 156.80, '2026-10-01T12:00:00Z');
