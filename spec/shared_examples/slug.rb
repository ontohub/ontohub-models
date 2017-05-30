# frozen_string_literal: true

RSpec.shared_examples 'an object that has a slug' do |invalid_format|
  let(:slug_base) { subject.class.instance_variable_get(:@slug_base) }

  context 'validations' do
    it 'is invalid without a unique slug' do
      attribute = subject.class.instance_variable_get(:'@slug_base')
      subject.send("#{attribute}=", other_subject.send(attribute))
      expect(subject.valid?).to be(false)
    end

    it 'is invalid with invalid format' do
      original = subject.class.instance_variable_get(:@slug_postprocess)
      stub = ->(_slug) { invalid_format }
      subject.class.instance_variable_set(:@slug_postprocess, stub)
      expect(subject.valid?).to be(false)
      subject.class.instance_variable_set(:@slug_postprocess, original)
    end

    context 'with duplicate slug' do
      before do
        subject.dup.save
        subject.valid?
      end

      it 'has no slug errors' do
        expect(subject.errors[:slug]).to be_empty
      end

      it 'has slug_base errors' do
        expect(subject.errors[slug_base]).not_to be_empty
      end
    end
  end

  context 'on create' do
    before { subject.save }
    it 'the slug is set correctly' do
      expect(subject.slug).
        to eq(subject.
          send(:do_slug_postprocess, Slug.sluggify(subject.send(slug_base))))
    end
  end

  context 'on update' do
    before { subject.save }

    context 'changing the slug base' do
      let!(:old_slug) { subject.slug }

      before do
        subject.send("#{slug_base}=", "#{subject.send(slug_base)}_changed")
        subject.save
      end

      it 'the slug is not changed' do
        expect(subject.slug).to eq(old_slug)
      end
    end
  end

  it 'exposes to_param correctly' do
    expect(subject.to_param).to eq(subject.slug)
  end
end
