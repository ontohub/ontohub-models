# frozen_string_literal: true

# We need to monkey-patch sequel-rails to allow for non-standard migrations
# directories.
# TODO Create a pull request at https://github.com/TalentBox/sequel-rails
module SequelRails
  # The migrations class is used for rake db:migrate[:*]
  class Migrations
    class << self
      def migrations_dir
        root_path = Gem::Specification.find_by_name('ontohub-models').gem_dir
        Pathname.new(root_path).join('db/migrate')
      end
    end
  end
end
