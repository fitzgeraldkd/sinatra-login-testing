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
    BCrypt::Engine.hash_secret(password, user.password_salt) == user.password_hash
  end
end