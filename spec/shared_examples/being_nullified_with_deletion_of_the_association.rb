# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
RSpec.shared_examples('being nullified with deletion of the association') do |association|
  # rubocop:enable Metrics/LineLength
  it "is set null when the #{association} is deleted" do
    expect { subject.public_send(association).delete }.
      to change { subject.class.find(id: subject.id).public_send(association) }.
      to(nil)
  end
end
