module Slug
  extend ActiveSupport::Concern

  class_methods do
    def slug_base(attribute)
      @slug_base = attribute
    end

    def slug_condition(method)
      @slug_condition = method
    end
  end

  def to_param
    slug
  end

  def before_validation
    set_slug if set_slug?
    super
  end

  private

  def set_slug?
    if slug_condition.nil?
      true
    elsif slug_condition.respond_to?(:call)
      # The proc/block is defined on the class, but must be executed on this
      # instance. `instance_exec` changes the context.
      instance_exec(&slug_condition)
    else
      send(slug_condition)
    end
  end

  def set_slug
    self.slug = send(slug_base)&.
      parameterize&.
      gsub(/\s/, '_')&.
      gsub(/[*.=]/,
           '*' => 'Star',
           '=' => 'Eq')
  end

  def slug_base
    self.class.instance_variable_get(:'@slug_base')
  end

  def slug_condition
    self.class.instance_variable_get(:'@slug_condition')
  end
end
