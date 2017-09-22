# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
RSpec.shared_examples('restricting the deletion of the association') do |association|
  # rubocop:enable Metrics/LineLength
  it "is raises an error when the #{association} is about to be deleted" do
    expect { subject.public_send(association).delete }.
      to raise_error(Sequel::ForeignKeyConstraintViolation)
  end
end
