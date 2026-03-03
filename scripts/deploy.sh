#!/bin/bash
set -e

# .env ファイルの存在確認
if [ ! -f .env ]; then
  echo "Error: .env file not found. Deployment aborted."
  exit 1
fi

echo "Logging in to GHCR..."
echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_ACTOR" --password-stdin

echo "Pulling latest images..."
docker compose -f docker-compose.prod.yml pull

echo "Starting containers..."
docker compose -f docker-compose.prod.yml up -d --force-recreate

echo "Waiting for health check..."
MAX_RETRIES=30
RETRY_COUNT=0
until [ $(docker compose -f docker-compose.prod.yml exec -T web curl -s -o /dev/null -w "%{http_code}" http://localhost/up) -eq 200 ]; do
  if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Health check failed after $MAX_RETRIES attempts."
    docker compose -f docker-compose.prod.yml logs web
    exit 1
  fi
  echo "Waiting for app to start... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 5
  RETRY_COUNT=$((RETRY_COUNT+1))
done

echo "Deployment successful!"
