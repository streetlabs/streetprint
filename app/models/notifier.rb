class Notifier < ActionMailer::Base
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "noreply@streetprint.org"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "noreply@streetprint.org"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user)
    subject       "Welcome to Streetprint"
    from          "noreply@streetprint.org"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
  
end