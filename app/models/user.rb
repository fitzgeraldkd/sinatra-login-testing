class User < ActiveRecord::Base
  def self.add_user(username:, password:)
    if User.find_by(username: username) == nil
      salt = BCrypt::Engine.generate_salt
      hash = BCrypt::Engine.hash_secret password, salt
      create(username: username, password_hash: hash, password_salt: salt)
      "User successfully added."
    else
      "This username already exists."
    end
  end

  def self.login(username:, password:)
    user = User.find_by(username: username)
    if user && BCrypt::Engine.hash_secret(password, user.password_salt) == user.password_hash
      user.update(login_token: SecureRandom.uuid, login_time: DateTime.now)
      {user_id: user.id, login_token: user.login_token}
    else
      "Invalid credentials."
    end
  end

  def self.current(login_token:)
    user = User.find_by(login_token: login_token)
    return user if user == nil
    if (DateTime.now.to_time - user.login_time) / 1.hours < 1
      user
    else
      user.logout
      nil
    end
  end

  def logout
    update(login_token: nil, login_time: nil)
    "Successfully logged out."
  end
end