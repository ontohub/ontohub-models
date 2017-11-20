# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
RSpec.shared_examples('being nullified with deletion of the association') do |association|
  # rubocop:enable Metrics/LineLength
  it "is set null when the #{association} is deleted" do
    id = subject.id
    expect { subject.public_send(association).delete }.
      to change { subject.class.first(id: id).public_send(association) }.
      to(nil)
  end
end
