# frozen_string_literal: true

RSpec.shared_examples 'an object with timestamps' do
  context 'without transactions', no_transaction: true do
    let!(:before_time) { Time.now }

    before do
      # Don't send emails
      allow_any_instance_of(User).to receive(:send_devise_notification)
      subject.save
      subject.reload
    end

    it 'sets the created_at timestamp on save' do
      expect(subject.created_at).to be > before_time
    end

    it 'has an updated_at value equal to the created_at value' do
      expect(subject.updated_at).to eq(subject.created_at)
    end

    it 'sets the updated_at value on update' do
      subject.save
      subject.reload
      expect(subject.updated_at).to be > subject.created_at
    end
  end
end
