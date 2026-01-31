# Fix for Marshal deserialization errors in sessions
# This happens when upgrading Ruby/Rails versions and old sessions exist

module SessionMarshalFix
  def load_session(env)
    super
  rescue ArgumentError => e
    if e.message.include?('dump format') || e.message.include?('user class')
      Rails.logger.warn "Session deserialization failed (#{e.message}), resetting session"
      # Return empty session with new session ID
      [Rack::Session::SessionId.new(SecureRandom.hex(16)), {}]
    else
      raise
    end
  end
end

# Patch the cookie store to handle Marshal errors gracefully
if defined?(ActionDispatch::Session::CookieStore)
  ActionDispatch::Session::CookieStore.prepend(SessionMarshalFix)
end

# Also patch the session hash accessor to handle Marshal errors
module SessionAccessFix
  def [](key)
    super
  rescue ArgumentError => e
    if e.message.include?('dump format') || e.message.include?('user class')
      Rails.logger.warn "Session access failed for key '#{key}': #{e.message}"
      nil
    else
      raise
    end
  end

  def fetch(key, *args, &block)
    super
  rescue ArgumentError => e
    if e.message.include?('dump format') || e.message.include?('user class')
      Rails.logger.warn "Session fetch failed for key '#{key}': #{e.message}"
      args.first
    else
      raise
    end
  end
end

# Monkey-patch session hash to handle Marshal errors
if defined?(ActionDispatch::Request::Session)
  ActionDispatch::Request::Session.prepend(SessionAccessFix)
end
