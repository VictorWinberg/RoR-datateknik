class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      email = auth.info.email
      user = User.where(:email => email).first if email

      # Connect to facebook
      if user.nil? && auth.provider == 'facebook'
        connectWithFacebook(auth)
      end

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info ? auth.extra.raw_info.name : "#{auth.uid}",
          username: auth.info.nickname || auth.uid,
          provider: "#{auth.provider}",
          email: email ? email : "#{auth.uid}@student.lu.se",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  # TODO: Use the friends feature
  def self.connectWithFacebook(auth)
    @graph = Koala::Facebook::API.new(auth.credentials.token, ENV["FACEBOOK_APP_SECRET"])
    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
