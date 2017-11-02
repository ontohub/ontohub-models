# frozen_string_literal: true

RSpec.shared_examples 'an object that has a slug set externally' do
  it 'exposes to_param correctly' do
    expect(subject.to_param).to eq(subject.slug)
  end
end
