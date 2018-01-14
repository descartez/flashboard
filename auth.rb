require 'bcrypt'

module Auth
  include BCrypt

  def password(password_hash)
    @password = Password.new(password_hash)
  end

  def login(password)

  end
end