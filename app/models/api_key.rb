# frozen_string_literal: true

# The API key model
class ApiKey < Sequel::Model
  DIGEST = 'SHA256'
  SALT = 'Ontohub API Key'

  plugin :devise
  devise

  class << self
    def verify(secret, user_key)
      ApiKey.first(key: digest(secret, user_key))
    end

    # Generates a unique API key. Returns a hash with :raw and :encoded keys.
    # The :encoded value needs to be saved in the database.
    # The :raw value is the key that needs to be passed to the client.
    def generate(secret, length)
      loop do
        raw_key = generate_raw_key(length)
        encoded_key = digest(secret, raw_key)
        if ApiKey.where(key: encoded_key).empty?
          break {encoded: encoded_key, raw: raw_key}
        end
      end
    end

    def digest(secret, raw_key)
      OpenSSL::HMAC.hexdigest(DIGEST, key(secret), raw_key)
    end

    protected

    def key(secret)
      generator(secret).generate_key(SALT)
    end

    def generator(secret)
      ActiveSupport::CachingKeyGenerator.
        new(ActiveSupport::KeyGenerator.new(secret))
    end

    def generate_raw_key(length)
      real_length = (length * 3) / 4
      pre_key = SecureRandom.urlsafe_base64(real_length)
      # Replace characters that look alike in some fonts
      pre_key.tr('lIO0', 'sxyz')
    end
  end
end
