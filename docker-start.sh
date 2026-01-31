#!/bin/bash
set -e

# Remove any existing server PID file
rm -f tmp/pids/server.pid

# Change to app directory
cd /app

# Create sphinx directories
mkdir -p /app/db/sphinx/production /app/log

# Generate Sphinx configuration using ThinkingSphinx
echo "Generating Sphinx configuration with ThinkingSphinx..."
bundle exec rake ts:configure RAILS_ENV=production

# Build the Sphinx indexes
echo "Building Sphinx indexes..."
bundle exec rake ts:index RAILS_ENV=production

# Start Sphinx daemon (only if not already running)
echo "Starting Sphinx daemon..."
if ! pgrep -f "searchd.*production.sphinx.conf" > /dev/null; then
  bundle exec rake ts:start RAILS_ENV=production
else
  echo "Sphinx daemon already running"
fi

# Start Rails server with Puma
echo "Starting Rails server with Puma..."
cd /app && exec bundle exec puma -C config/puma.rb
