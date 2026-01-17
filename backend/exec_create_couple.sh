#!/bin/bash
cd /Users/alexandre/Apps/couple-app-starter/backend
sqlite3 db.sqlite3 < create_couple.sql
echo "✅ Couple créé dans la base de données!"
sqlite3 db.sqlite3 "SELECT 'Couple ID=' || id || ', User1=' || user1_id || ', User2=' || user2_id || ', Code=' || pairing_code FROM couples_couple;"
