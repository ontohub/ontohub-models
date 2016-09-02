class Repository < Sequel::Model
  plugin :timestamps

  def before_create
    self.slug = name.parameterize
    super
  end
end
