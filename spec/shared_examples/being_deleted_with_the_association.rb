# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
RSpec.shared_examples('being deleted with the association') do |association, primary_key_columns = nil|
  # rubocop:enable Metrics/LineLength
  it "is deleted when the #{association} is deleted" do
    # For example, SignatureSymbol has a compound primary key. Use the second
    # argument to support this.
    if primary_key_columns.is_a?(Array)
      primary_key = {}
      primary_key_columns.each { |c| primary_key[c] = subject.public_send(c) }
    end
    primary_key ||= {id: subject.id}

    expect { subject.public_send(association).delete }.
      to change { subject.class.first(primary_key) }.
      to(nil)
  end
end
