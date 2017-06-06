# frozen_string_literal: true

RSpec.shared_examples 'an object that has a URL' do
  context 'validations' do
    it 'is invalid without url_path' do
      subject.url_path_method = ->(_resource) { nil }
      expect(subject.valid?).to be(false)
    end

    it 'is invalid with the wrong url_path format' do
      subject.url_path_method = ->(_resource) { 'foobar' }
      expect(subject.valid?).to be(false)
    end

    it 'add an error if the url_path is blank' do
      subject.url_path_method = nil
      subject.valid?
      expect(subject.errors[:url_path]).not_to be_empty
    end

    it 'add an error if the url_path does not begin with a slash' do
      # Trigger url_path computation
      subject.valid?
      subject.url_path_method = ->(s) { s.url_path.sub(%r{\A/}, '') }
      subject.valid?
      expect(subject.errors[:url_path]).not_to be_empty
    end
  end

  context 'url' do
    let(:prefix) { 'http://pre.fix' }

    it 'prepends the prefix to the url_path and adds a slash' do
      expect(subject.url(prefix)).to eq("#{prefix}#{subject.url_path}")
    end

    it 'prepends the prefix to the url_path without doubling the slash' do
      expect(subject.url("#{prefix}/")).to eq("#{prefix}#{subject.url_path}")
    end
  end
end
