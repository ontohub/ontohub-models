# frozen_string_literal: true

RSpec.shared_examples 'an object that has a slug' do
  let(:slug_base) { subject.class.instance_variable_get(:@slug_base) }

  context 'validations' do
    it { is_expected.to validate_unique(:slug) }
    it { is_expected.to validate_format(subject.send(:slug_format), :slug) }

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
