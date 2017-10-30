# frozen_string_literal: true

# Class to hold a user's public key
class PublicKey < Sequel::Model
  many_to_one :user
  plugin :validation_helpers

  def before_validation
    self.fingerprint = key_fingerprint
  end

  def validate
    validates_presence %i(key name user)

    if new? && PublicKey.find(user_id: user_id, name: name)
      errors.add(:name, 'is already taken')
    end

    errors.add(:key, 'is invalid') unless fingerprint
  end

  private

  def key_fingerprint
    return @key_fingerprint if @key_fingerprint
    return nil if key.blank?
    decoded_key = Base64.strict_decode64(key.split(' ').last)
    @key_fingerprint = Digest::MD5.hexdigest(decoded_key)
  rescue ArgumentError => _
    nil
  end
end
