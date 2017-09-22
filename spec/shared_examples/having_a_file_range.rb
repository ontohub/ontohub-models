# frozen_string_literal: true

RSpec.shared_examples('having a file_range') do |column_name = :file_range|
  context 'blank' do
    before do
      subject.public_send("#{column_name}_id=", nil)
      subject.save
    end

    it 'is nil' do
      expect(subject.public_send(column_name)).to be(nil)
    end
  end

  context 'present' do
    it_behaves_like('it has a', column_name, FileRange)
    it_behaves_like('being nullified with deletion of the association',
                    column_name)
  end
end
