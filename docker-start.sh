#!/bin/bash
set -e

# Remove any existing server PID file
rm -f tmp/pids/server.pid

# Change to app directory
cd /app

# Configure and start Manticore Search (without using rake to avoid load order issues)
echo "Configuring Manticore Search..."

# Clean up any stale Sphinx/Manticore files
echo "Cleaning up stale Sphinx files..."
rm -f /app/log/searchd.pid
rm -f /app/log/searchd.log
rm -f /app/log/searchd.query.log
rm -f /var/lib/manticore/binlog.lock
rm -f /var/lib/manticore/data/binlog.*

# Try to stop any existing daemon
/usr/bin/searchd --config /app/config/development.sphinx.conf --stop 2>/dev/null || true

# Wait a moment for daemon to fully stop
sleep 2

# Create sphinx directories
mkdir -p /app/db/sphinx/development /app/log

# Generate Sphinx configuration using ThinkingSphinx
echo "Generating Sphinx configuration with ThinkingSphinx..."
bundle exec rake ts:configure RAILS_ENV=development

# Build the Sphinx indexes
echo "Building Sphinx indexes..."
bundle exec rake ts:index RAILS_ENV=development

# Start Sphinx daemon
echo "Starting Sphinx daemon..."
bundle exec rake ts:start RAILS_ENV=development || echo "Sphinx daemon already running or started successfully"

# Start Rails server with Puma
echo "Starting Rails server with Puma..."
cd /app && exec bundle exec puma -C config/puma.rb
