DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY autoincrement,
  fname STRING NOT NULL,
  lname STRING NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY autoincrement,
  title STRING NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY autoincrement,
  user_id INTEGER NOT NULL REFERENCES users(id),
  question_id INTEGER NOT NULL REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY autoincrement,
  question_id INTEGER NOT NULL REFERENCES questions(id),
  parent_id INTEGER REFERENCES replies(id),
  user_id INTEGER NOT NULL REFERENCES users(id),
  reply_body VARCHAR(255) NOT NULL
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY autoincrement,
  user_id INTEGER NOT NULL REFERENCES users(id),
  question_id INTEGER NOT NULL REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jade', 'McPherson'),
  ('Bob', 'McPherson'),
  ('Kim', 'McPherson');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('hows this work?', 'please tell me', 1),
  ('getting no replies', 'someone answer!', 1),
  ('what a fun thing!', 'no question really', 2),
  ('moms question', 'heres my mom question', 3);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 3),
  (1, 4),
  (2, 1),
  (2, 3),
  (3, 3),
  (2, 4);

INSERT INTO
  replies (question_id, parent_id, user_id, reply_body)
VALUES
  (1, NULL, 2, 'I dont know either - Dad'),
  (1, 1, 1, 'Thanks dad'),
  (1, 1, 3, 'Hey guys.'),
  (4, NULL, 1, 'Hi Mom!');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 1),
  (3, 1),
  (1, 4),
  (1, 3),
  (2, 3),
  (3, 3);
