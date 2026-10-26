#!/usr/bin/env bash
set -euo pipefail

ETC="${TURTLE_HOME:-/opt/turtle}/etc"
DATA_DIR="${DATA_DIR:-/opt/turtle/data}"
LOGS_DIR="${LOGS_DIR:-/opt/turtle/logs}"
SQL_DIR="${SQL_DIR:-/opt/turtle/sql}"

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-mangos}"
DB_PASSWORD="${DB_PASSWORD:-mangos}"
DB_LOGIN="${DB_LOGIN:-tw_logon}"
DB_WORLD="${DB_WORLD:-tw_world}"
DB_CHAR="${DB_CHAR:-tw_char}"
DB_LOGS="${DB_LOGS:-tw_logs}"

WORLD_PORT="${WORLD_PORT:-8090}"
REALM_PORT="${REALM_PORT:-3724}"
REALM_ID="${REALM_ID:-1}"
BIND_IP="${BIND_IP:-0.0.0.0}"

LOG_SQL="${LOG_SQL:-0}"
AUTO_UPDATE="${DATABASE_AUTOUPDATE_ENABLED:-1}"
LFT_BOTFILL="${LFT_BOTFILL_ENABLE:-1}"
SOLO_DUNGEON_REPOP="${SOLO_DUNGEON_REPOP_ALIVE_ENABLE:-1}"
LEECH_ENABLE="${LEECH_ENABLE:-1}"

AI_PLAYERBOT_ENABLED="${AI_PLAYERBOT_ENABLED:-1}"
AI_MIN_RANDOM_BOTS="${AI_MIN_RANDOM_BOTS:-10}"
AI_MAX_RANDOM_BOTS="${AI_MAX_RANDOM_BOTS:-10}"

DB_INFO() {
  local db="$1"
  printf '%s;%s;%s;%s;%s' "${DB_HOST}" "${DB_PORT}" "${DB_USER}" "${DB_PASSWORD}" "${db}"
}

set_conf() {
  local file="$1" key="$2" value="$3"
  if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "${file}"; then
    sed -i -E "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${value}|" "${file}"
  else
    printf '\n%s = %s\n' "${key}" "${value}" >> "${file}"
  fi
}

ensure_conf() {
  local dist="$1" conf="$2"
  if [[ ! -f "${conf}" ]]; then
    if [[ ! -f "${dist}" ]]; then
      echo "Missing config template: ${dist}" >&2
      exit 1
    fi
    cp "${dist}" "${conf}"
  fi
}

mkdir -p "${ETC}"

ensure_conf "${ETC}/mangosd.conf.dist" "${ETC}/mangosd.conf"
ensure_conf "${ETC}/realmd.conf.dist" "${ETC}/realmd.conf"

if [[ -f "${ETC}/aiplayerbot.conf.dist" ]]; then
  ensure_conf "${ETC}/aiplayerbot.conf.dist" "${ETC}/aiplayerbot.conf"
fi
if [[ -f "${ETC}/ahbot.conf.dist" ]]; then
  ensure_conf "${ETC}/ahbot.conf.dist" "${ETC}/ahbot.conf"
fi

# mangosd
set_conf "${ETC}/mangosd.conf" "LoginDatabase.Info" "\"$(DB_INFO "${DB_LOGIN}")\""
set_conf "${ETC}/mangosd.conf" "WorldDatabase.Info" "\"$(DB_INFO "${DB_WORLD}")\""
set_conf "${ETC}/mangosd.conf" "CharacterDatabase.Info" "\"$(DB_INFO "${DB_CHAR}")\""
set_conf "${ETC}/mangosd.conf" "LogsDatabase.Info" "\"$(DB_INFO "${DB_LOGS}")\""
set_conf "${ETC}/mangosd.conf" "DataDir" "\"${DATA_DIR}\""
set_conf "${ETC}/mangosd.conf" "LogsDir" "\"${LOGS_DIR}\""
set_conf "${ETC}/mangosd.conf" "WorldServerPort" "${WORLD_PORT}"
set_conf "${ETC}/mangosd.conf" "BindIP" "\"${BIND_IP}\""
set_conf "${ETC}/mangosd.conf" "RealmID" "${REALM_ID}"
set_conf "${ETC}/mangosd.conf" "LogSQL" "${LOG_SQL}"
set_conf "${ETC}/mangosd.conf" "Database.AutoUpdate.Enabled" "${AUTO_UPDATE}"
set_conf "${ETC}/mangosd.conf" "Database.AutoUpdate.Path" "\"${SQL_DIR}/database_updates/\""
set_conf "${ETC}/mangosd.conf" "LFT.BotFill.Enable" "${LFT_BOTFILL}"
set_conf "${ETC}/mangosd.conf" "SoloDungeonRepopAlive.Enable" "${SOLO_DUNGEON_REPOP}"
set_conf "${ETC}/mangosd.conf" "Leech.Enable" "${LEECH_ENABLE}"
# Realm type (0 normal, 1 PvP, 6 RP, 8 RP-PvP). Unset keeps the shipped default, which is 6 (RP).
if [[ -n "${GAME_TYPE:-}" ]]; then
  set_conf "${ETC}/mangosd.conf" "GameType" "${GAME_TYPE}"
fi

# realmd (note: key name has no dots between LoginDatabase and Info)
set_conf "${ETC}/realmd.conf" "LoginDatabaseInfo" "\"$(DB_INFO "${DB_LOGIN}")\""
set_conf "${ETC}/realmd.conf" "RealmServerPort" "${REALM_PORT}"
set_conf "${ETC}/realmd.conf" "BindIP" "\"${BIND_IP}\""

if [[ -f "${ETC}/aiplayerbot.conf" ]]; then
  set_conf "${ETC}/aiplayerbot.conf" "AiPlayerbot.Enabled" "${AI_PLAYERBOT_ENABLED}"
  set_conf "${ETC}/aiplayerbot.conf" "AiPlayerbot.MinRandomBots" "${AI_MIN_RANDOM_BOTS}"
  set_conf "${ETC}/aiplayerbot.conf" "AiPlayerbot.MaxRandomBots" "${AI_MAX_RANDOM_BOTS}"

  # Ported custom features (F1 populate-around-players, F2 travel parties). Only written when
  # the env var is set, so an unset var leaves the shipped default (off) alone. Values are
  # passed through verbatim - quote coordinate strings in the environment, e.g.
  # AI_TRAVEL_PARTY_DEST='"1,-844.0,-2037.0,80.5"'.
  set_conf_if_set() {
    local key="$1" value="$2"
    if [[ -n "${value}" ]]; then
      set_conf "${ETC}/aiplayerbot.conf" "${key}" "${value}"
    fi
  }
  set_conf_if_set "AiPlayerbot.PopulateAroundPlayers" "${AI_POPULATE_AROUND_PLAYERS:-}"
  set_conf_if_set "AiPlayerbot.TravelParties" "${AI_TRAVEL_PARTIES:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyTestMode" "${AI_TRAVEL_PARTY_TEST_MODE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyMuster" "${AI_TRAVEL_PARTY_MUSTER:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyDest" "${AI_TRAVEL_PARTY_DEST:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyLevels" "${AI_TRAVEL_PARTY_LEVELS:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyMoveMode" "${AI_TRAVEL_PARTY_MOVE_MODE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyLeaderStrip" "${AI_TRAVEL_PARTY_LEADER_STRIP:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyArriveZ" "${AI_TRAVEL_PARTY_ARRIVE_Z:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyLowLevelMaxRoute" "${AI_TRAVEL_PARTY_LOW_LEVEL_MAX_ROUTE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyLowLevelBand" "${AI_TRAVEL_PARTY_LOW_LEVEL_BAND:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyRequirePlayerZone" "${AI_TRAVEL_PARTY_REQUIRE_PLAYER_ZONE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyClosestTownPct" "${AI_TRAVEL_PARTY_CLOSEST_TOWN_PCT:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyRaidPct" "${AI_TRAVEL_PARTY_RAID_PCT:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyCrossMapProbe" "${AI_TRAVEL_PARTY_CROSS_MAP_PROBE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyUseRegistry" "${AI_TRAVEL_PARTY_USE_REGISTRY:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyMaxConcurrent" "${AI_TRAVEL_PARTY_MAX_CONCURRENT:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyMaxDeaths" "${AI_TRAVEL_PARTY_MAX_DEATHS:-}"
  set_conf_if_set "AiPlayerbot.TravelPartyEnterInstance" "${AI_TRAVEL_PARTY_ENTER_INSTANCE:-}"
  set_conf_if_set "AiPlayerbot.TravelPartySpawnInterval" "${AI_TRAVEL_PARTY_SPAWN_INTERVAL:-}"
  set_conf_if_set "AiPlayerbot.PopulateDensityDefault" "${AI_POPULATE_DENSITY_DEFAULT:-}"
  set_conf_if_set "AiPlayerbot.PopulateDensityOverrides" "${AI_POPULATE_DENSITY_OVERRIDES:-}"
  set_conf_if_set "AiPlayerbot.PopulateProbTeleport" "${AI_POPULATE_PROB_TELEPORT:-}"
  set_conf_if_set "AiPlayerbot.PopulatePeerAnyLevelPoints" "${AI_POPULATE_PEER_ANY_LEVEL_POINTS:-}"
  set_conf_if_set "AiPlayerbot.RandomBotForcePvp" "${AI_RANDOM_BOT_FORCE_PVP:-}"
  set_conf_if_set "AiPlayerbot.WorldPvpSeek" "${AI_WORLD_PVP_SEEK:-}"
set_conf_if_set "AiPlayerbot.WorldPvpSeekBotPercent" "${AI_WORLD_PVP_SEEK_BOT_PERCENT:-}"
fi

# Local pins: conf-overrides/<name>.conf holds "Key = Value" lines applied on top of the rendered
# <name>.conf, so values we chose survive a new image whose .dist defaults changed.
for o in /opt/turtle/conf-overrides/*.conf; do
  [[ -f "${o}" && -f "${ETC}/$(basename "${o}")" ]] || continue
  while IFS= read -r line || [[ -n "${line}" ]]; do
    [[ "${line}" =~ ^[[:space:]]*([A-Za-z0-9_.]+)[[:space:]]*=[[:space:]]*(.*[^[:space:]])[[:space:]]*$ ]] || continue
    set_conf "${ETC}/$(basename "${o}")" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
  done < "${o}"
done

mkdir -p "${LOGS_DIR}"
# Writable for the turtle user (configs may be regenerated each start).
chown -R turtle:turtle "${ETC}" "${LOGS_DIR}" 2>/dev/null || true

echo "Configs rendered under ${ETC}"
