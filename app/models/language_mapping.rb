# frozen_string_literal: true

# The LanguageMapping model describes a translation from one Language into
# another.
class LanguageMapping < Sequel::Model
  many_to_one :source, class: Language
  many_to_one :target, class: Language
end
