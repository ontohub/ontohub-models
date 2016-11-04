# frozen_string_literal: true

# The Slug module allows a model to have a slug for routing. To use it in a
# model, which induces the slug from the +name+ attribute, the model needs to
# call +slug_base :name+ (required).
#
# It can optionally call +slug_condition :condition_method+ which determines
# whether or not to change the slug.
#
# If the condition holds, the slug gets set/updated in a before_save hook.
#
# At the end of the update, the optional +slug_postprocess+ lambda is called,
# which expects one argument (the preset slug string). This method must return
# the slug as it is supposed to be saved.
#
# During the validations, the format of the slug is checked against the optional
# +slug_format+ regular expression. If no format is given, a default format is
# used.
#
#
# The model must have a `slug` column in the database.
#
# Usage:
#   class MyModel
#     include Slug
#
#     slug_base :name
#
#     # Optional: Specify when the slug gets set/updated.
#     slug_condition :new?
#     # OR
#     slug_condition ->() { name.changed? }
#
#     # Optional: Add some post-processing to set the slug.
#     slug_postprocess ->(slug) { slug.upcase }
#
#     # Optional: Specify the validation format of the slug.
#     slug_format /\A[A-Z0-9\-_]+\z/
#   end
module Slug
  extend ActiveSupport::Concern
  DEFAULT_SLUG_FORMAT = /\A[a-z0-9\-_]+\z/

  class_methods do
    def slug_base(attribute)
      @slug_base = attribute
    end

    def slug_condition(method)
      @slug_condition = method
    end

    def slug_postprocess(callable)
      @slug_postprocess = callable
    end

    def slug_format(format)
      @slug_format = format
    end

    def inherited(subclass)
      %w(@slug_base @slug_condition @slug_postprocess @slug_format).
        each do |instance_var|
        instance_var_value = instance_variable_get(instance_var)
        subclass.instance_variable_set(instance_var, instance_var_value)
      end
      super
    end
  end

  def self.sluggify(string)
    string&.
      downcase&.
      gsub(/[*.=]/,
           '*' => 'Star',
           '=' => 'Eq')&.
      parameterize(preserve_case: true)&.
      gsub(/\s/, '_')
  end

  def to_param
    slug
  end

  def before_validation
    set_slug if set_slug?
    super
  end

  def validate
    validates_presence slug_base
    validates_unique :slug
    validates_format(slug_format, :slug)
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
    self.slug = Slug.sluggify(send(slug_base))
    self.slug = do_slug_postprocess(slug)
  end

  def do_slug_postprocess(slug)
    instance_exec(slug, &slug_postprocess)
  end

  def slug_base
    self.class.instance_variable_get(:'@slug_base')
  end

  def slug_condition
    self.class.instance_variable_get(:'@slug_condition')
  end

  def slug_postprocess
    identity = ->(x) { x }
    self.class.instance_variable_get(:'@slug_postprocess') || identity
  end

  def slug_format
    self.class.instance_variable_get(:'@slug_format') || DEFAULT_SLUG_FORMAT
  end
end
