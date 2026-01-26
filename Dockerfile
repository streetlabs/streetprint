# Rails 5.2 with Ruby 2.6
FROM ruby:2.6-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    imagemagick \
    libmagickwand-dev \
    git \
    curl \
    wget \
    tar \
    patch \
    && rm -rf /var/lib/apt/lists/*

# Install Manticore Search (modern Sphinx replacement)
# Manticore is compatible with Thinking Sphinx 4.4.1 and actively maintained
RUN wget https://repo.manticoresearch.com/manticore-repo.noarch.deb && \
    dpkg -i manticore-repo.noarch.deb && \
    apt-get update && \
    apt-get install -y manticore manticore-extra && \
    rm manticore-repo.noarch.deb && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler 2.x for Rails 5.2 (Ruby 2.6 compatible)
RUN gem install bundler -v '~> 2.3.0'

# Copy Gemfile and Gemfile.lock FIRST for Docker layer caching
COPY Gemfile Gemfile.lock* ./

# Install gems via Bundler (deployment mode installs git sources properly)
RUN bundle config set --local deployment 'false' && \
    bundle config set --local path '/usr/local/bundle' && \
    bundle install --jobs=4 --retry=3

# Rails 5.2 is compatible with Ruby 2.6 and mysql2 0.5.x

# Copy startup script
COPY docker-start.sh /docker-start.sh
RUN chmod +x /docker-start.sh

# Copy application files
COPY . .

# Ensure bundle is properly set up with git sources
RUN bundle check || bundle install

# Set environment to development by default
ENV RAILS_ENV=development

# Expose port 3000
EXPOSE 3000

# Create log and tmp directories
RUN mkdir -p log tmp/pids tmp/cache tmp/sockets

# Start the Rails server
CMD ["/docker-start.sh"]
