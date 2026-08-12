#!/usr/bin/env bash
set -euo pipefail

RESTIC_REPOSITORY="/mnt/storage/backups/restic/krem-pi-temp"
RESTIC_PASSWORD_FILE="/home/kremflote/.config/restic/krem-pi-temp.pass"
EXCLUDES="/home/kremflote/.config/restic/critical-excludes.txt"
STAGING="/mnt/storage/backups/staging/db-dumps"

mkdir -p "$STAGING"
chmod 700 "$STAGING"

echo "Dumping Nextcloud database..."
docker exec nextcloud-db sh -lc 'mariadb-dump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  > "$STAGING/nextcloud.sql"

echo "Dumping Firefly database..."
docker exec firefly-db sh -lc 'mariadb-dump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  > "$STAGING/firefly.sql"

echo "Backing up compose files, configs, and database dumps..."
sudo restic \
  -r "$RESTIC_REPOSITORY" \
  --password-file "$RESTIC_PASSWORD_FILE" \
  backup \
  /home/kremflote/infra/docker-compose.yml \
  /home/kremflote/media-server/docker-compose.yml \
  /home/kremflote/infra/config \
  /home/kremflote/media-server/config \
  "$STAGING" \
  --exclude-file "$EXCLUDES" \
  --tag critical

echo "Forgetting old critical snapshots according to retention policy..."
sudo restic \
  -r "$RESTIC_REPOSITORY" \
  --password-file "$RESTIC_PASSWORD_FILE" \
  forget \
  --tag critical \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 3 \
  --prune

echo "Checking repository..."
sudo restic \
  -r "$RESTIC_REPOSITORY" \
  --password-file "$RESTIC_PASSWORD_FILE" \
  check

echo "Backup complete."
