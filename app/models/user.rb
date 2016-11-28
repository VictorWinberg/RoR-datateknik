class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:google_oauth2, :identity, :cas, :cas3]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      if auth.provider == :cas || auth.provider == :cas3
        user.email = user.name + "@student.lu.se"
      end
      # user.password = Devise.friendly_token[0,20]
      # user.image = auth.info.image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_oauth2_data"] && session["devise.google_oauth2_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
