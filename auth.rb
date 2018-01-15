require 'bcrypt'

module Auth
  include BCrypt

  def password(password_hash)
    @password = Password.new(password_hash)
  end

  def login(password)
    if password == @board_config['password_string']
      session['logged_in'] = true
    end
  end

  def auth!
    if !!session['logged_in']
      return true
    else
      return false
    end
  end
end