# frozen_string_literal: true

# Make Sequel::Model objects pass the ActiveModel::Serializer::Lint tests,
# which should mean full ActiveModelSerializer compliance.
#
# The models are only compatible to ActiveModelSerializer, if they have the
# updated_at timestamp attribute. The timestamps need to be plugged in
# explicitly in each model.
Sequel::Model.plugin :active_model
Sequel::Model.plugin :active_model_serializer
