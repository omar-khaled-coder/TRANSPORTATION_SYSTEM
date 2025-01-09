# This class handles encoding and decoding JWT tokens for authentication.

class JsonWebToken
  # The secret key used for signing and verifying JWT tokens.
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # Encodes the payload into a JWT token with an optional expiration time (default 24 hours).
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodes the JWT token and returns the payload as a hash. Returns nil if invalid.
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end
end
