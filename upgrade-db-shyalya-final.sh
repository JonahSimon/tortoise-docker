#!/usr/bin/env bash
# One-shot DB upgrade for moving an Aug-2026 tortoise-wow DB onto the merge-shyalya-final image
# (written 2026-09-29). Run with the db container up and mangosd stopped, AFTER snapshotting the volume.
#   usage: upgrade-db-shyalya-final.sh <db-container> <image>
# Why it exists: the AutoUpdater applies sql/database_updates only. Shyalya's tip also needs
#  1. sql/character_updates/20260708055500 (composite index) BEFORE its auto migration 20260903211500 drops it,
#  2. the module's new 20260906_ahbot_items.sql (mangosd asserts if tw_char.ahbot_items is missing),
#  3. the 2026-09-03..09-10 world batch, whose INSERTs collide with rows our older base already had
#     (duplicate PRIMARY keys), so they are applied with `mariadb -f` and recorded by hand.
#     NOT benign: a multi-row INSERT with one duplicate fails whole. After this script, apply
#     fix-dupkey-rows-2026-09-30.sql (20 REPLACE rows: broadcast_text, custom_character_skins,
#     spell_proc_event 44070, gossip_menu_option), found by diffing INSERT vs REPLACE replays.
set -u
C=${1:?db container}; IMG=${2:?image}
P=$(grep '^DB_ROOT_PASSWORD=' ~/docker/tortoise-wow/.env | cut -d= -f2-)
m(){ docker exec -i -e MYSQL_PWD="$P" "$C" mariadb -uroot "$@"; }
m -e "ALTER TABLE tw_char.ai_playerbot_random_bots ADD INDEX IF NOT EXISTS idx_owner_bot_event (owner, bot, event)"
docker run --rm --entrypoint cat "$IMG" /opt/turtle/sql/playerbots/characters/20260906_ahbot_items.sql | m tw_char
for pair in "tw_world world" "tw_char character"; do
  set -- $pair; db=$1; dir=$2
  applied=$(m -N -e "SELECT Name FROM $db.migrations" | sort)
  for f in $(docker run --rm --entrypoint sh "$IMG" -c "ls /opt/turtle/sql/database_updates/$dir" | sort); do
    n=${f%.sql}
    grep -qx "$n" <<<"$applied" && continue
    tmp=$(mktemp); docker run --rm --entrypoint cat "$IMG" /opt/turtle/sql/database_updates/$dir/$f > "$tmp"
    h=$(sha1sum "$tmp" | cut -d' ' -f1 | tr a-f A-F)   # the AutoUpdater's hash: SHA1 of the raw file, upper case
    out=$(m -f "$db" < "$tmp" 2>&1); rm -f "$tmp"
    m -e "INSERT INTO $db.migrations (Name,Module,Hash,AppliedAt) VALUES ('$n','','$h',NOW())"
    echo "$db $n errors=$(grep -c '^ERROR' <<<"$out") $(grep '^ERROR' <<<"$out" | head -1 | cut -c1-120)"
  done
done
