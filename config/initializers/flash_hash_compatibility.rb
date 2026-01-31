# Rails 5.2 compatibility fix for FlashHash constant
# Some gems reference ActionController::Flash::FlashHash which was moved

# In Rails 5.2, FlashHash is at ActionDispatch::Flash::FlashHash
if defined?(ActionDispatch::Flash::FlashHash) && !defined?(ActionController::Flash::FlashHash)
  module ActionController
    module Flash
      FlashHash = ActionDispatch::Flash::FlashHash
    end
  end
end
