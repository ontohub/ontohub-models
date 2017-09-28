# frozen_string_literal: true

RSpec.shared_examples('having a number') do |factory, dependent_association|
  it 'increments the number' do
    subject.save
    other = create(factory,
                   dependent_association =>
                     subject.public_send(dependent_association))
    expect(other.number).to eq(subject.number + 1)
  end

  it 'sets the number to 1 on a new dependent association' do
    create(factory)
    subject.save
    expect(subject.number).to eq(1)
  end
end
