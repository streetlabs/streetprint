# Docker Setup for StreetPrint 5

This guide will help you get the Rails 2.3.3 application running in Docker.

## Prerequisites

- Docker Desktop installed and running
- Your local MySQL database (`sp5`) running on `localhost:3306` with production data

## Quick Start

### Option 1: Using Your Local MySQL Database

This is the simplest option since you already have the `sp5` database set up locally.

```bash
# Build and start the application
docker-compose up --build

# The app will be available at http://localhost:3000
```

The Rails container will connect to your host MySQL at `localhost:3306` using `host.docker.internal`.

### Option 2: Using MySQL in Docker (Separate Database)

If you want an isolated Docker environment:

1. Edit `docker-compose.yml` and uncomment the `db` service
2. Import your data into the Docker MySQL:

```bash
# Start just the MySQL container
docker-compose up -d db

# Import your database
docker-compose exec db mysql -u root sp5 < /path/to/your/dump.sql

# Start the web app
docker-compose up web
```

## Configuration

The application uses environment variables for database connection:

- `DATABASE_HOST` - MySQL host (default: `host.docker.internal`)
- `DATABASE_NAME` - Database name (default: `sp5`)
- `DATABASE_USER` - Database user (default: `root`)
- `DATABASE_PASSWORD` - Database password (default: empty)
- `DATABASE_PORT` - Database port (default: `3306`)

## Image URLs

The production S3 image URLs are configured in `app/models/cloudfile_photo.rb`:

```ruby
S3_BASE_URL = "https://sp5-public.assets.streetprint.org"
```

These should work as-is since the images are already hosted on S3.

## Troubleshooting

### "Can't connect to MySQL server"

If you see connection errors:

1. Make sure your local MySQL is running: `mysql -u root -p sp5 -e "SELECT 1;"`
2. Check that the database name is correct (should be `sp5`)
3. On Linux, you may need to use `host=172.17.0.1` instead of `host.docker.internal`

### "Unknown database 'sp5'"

Make sure your database is named exactly `sp5`. Check with:

```bash
mysql -u root -e "SHOW DATABASES;"
```

### Gem Installation Failures

Some gems are old and may not install cleanly. The Dockerfile marks gem installations as optional with `|| true`. If critical gems fail:

1. Check the build output for specific errors
2. You may need to manually install problematic gems
3. Some gems (like thinking-sphinx) are optional for basic functionality

### Rails 2.3.3 Compatibility

This is a very old Rails version (2009). Some things to note:

- Uses vendored Rails in `vendor/rails/`
- No Bundler (gems installed globally)
- WEBrick as the default server
- Old Ruby syntax and patterns

## Development Workflow

### Run Rails Console

```bash
docker-compose exec web script/console
```

### View Logs

```bash
docker-compose logs -f web
```

### Run Database Migrations (if needed)

```bash
docker-compose exec web rake db:migrate
```

### Restart the Server

```bash
docker-compose restart web
```

## Testing Without Thinking Sphinx

Thinking Sphinx (search) may not work out of the box in Docker. To test the app without it:

1. Comment out the sphinx configuration in models
2. Skip search-related routes/features initially
3. Focus on getting basic item/photo viewing working

## Next Steps

Once the app is running:

1. Test that you can view items: http://localhost:3000
2. Verify images are loading from S3
3. Check that the database connection is working
4. Review the logs for any errors

## Production Considerations

This Docker setup is for development/testing. For production:

- Use a production-grade web server (Passenger, Unicorn)
- Set `RAILS_ENV=production`
- Precompile assets
- Use proper MySQL credentials
- Configure proper logging
- Set up health checks
- Consider migrating to Rails 7 (see migration docs)
