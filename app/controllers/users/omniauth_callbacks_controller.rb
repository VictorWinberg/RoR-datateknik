class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def google_oauth2
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication # this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Google OAuth2") if is_navigational_format?
  #   else
  #     session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.from_omniauth(env["omniauth.auth"])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:google_oauth2, :identity].each do |provider|
    provides_callback_for provider
  end

  def failure
    redirect_to root_path
  end
end
