DELETE FROM couples_couple;
INSERT INTO couples_couple (id, partner_a_id, partner_b_id, created_at, updated_at)
VALUES (
  lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
  (SELECT id FROM accounts_user WHERE email='alice@example.com'),
  (SELECT id FROM accounts_user WHERE email='bob@example.com'),
  datetime('now'),
  datetime('now')
);
