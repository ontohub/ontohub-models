# frozen_string_literal: true

RSpec.describe Slug do
  it 'sluggify' do
    expect(Slug.sluggify('a_b/c-d  e-ö-ß * =')).
      to eq('a_b-c-d-e-o-ss-Star-Eq')
  end
end
