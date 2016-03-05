# name: discourse-email-verify-enhancement
# about:  https://meta.discourse.org/t/should-we-expect-avatars-to-be-propagated-using-discourse-sso-provider/35332/5?u=zh99998
# version: 0.1
# authors: zh99998 <zh99998@gmail.com>

after_initialize do

  UsersController.class_eval do
    def send_activation_email
      if current_user.blank? || !current_user.staff?
        RateLimiter.new(nil, "activate-hr-#{request.remote_ip}", 30, 1.hour).performed!
        RateLimiter.new(nil, "activate-min-#{request.remote_ip}", 6, 1.minute).performed!
      end
  
      @user = User.find_by_username_or_email(params[:username].to_s)
  
      raise Discourse::NotFound unless @user

      @user.update_attribute(:email, params[:email]) if !params[:email].blank?
  
      @email_token = @user.email_tokens.unconfirmed.active.first
      enqueue_activation_email if @user
      render nothing: true
    end
  end
end
