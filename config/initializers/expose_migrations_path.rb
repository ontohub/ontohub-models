# We need to monkey-patch sequel-rails to allow for non-standard migrations
# directories.
# TODO Create a pull request at https://github.com/TalentBox/sequel-rails
module SequelRails
  class Migrations
    class << self
      def migrations_dir
        File.join(Gem::Specification.find_by_name('ontohub_models').gem_dir,
                  'db/migrate')
      end
    end
  end
end

