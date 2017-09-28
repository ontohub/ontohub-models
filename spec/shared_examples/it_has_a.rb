# frozen_string_literal: true

RSpec.shared_examples('it has a') do |association, klass|
  it association.to_s do
    expect(subject.public_send(association)).to be_a(klass)
  end
end
