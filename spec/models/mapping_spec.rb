# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mapping do
  context 'superclass' do
    subject { build(:mapping) }
    it_behaves_like 'a loc_id_base'
  end

  context 'associations' do
    subject { create(:mapping) }

    context 'source' do
      it_behaves_like('it has a', :source, OMS)
      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it_behaves_like('it has a', :target, OMS)
      it_behaves_like('being deleted with the association', :target)
    end

    context 'signature_morphism' do
      it_behaves_like('it has a', :signature_morphism, SignatureMorphism)
      it_behaves_like('being deleted with the association', :signature_morphism)
    end

    context 'conservativity_status' do
      it_behaves_like('it has a', :conservativity_status, ConservativityStatus)
      it_behaves_like('being nullified with deletion of the association',
                      :conservativity_status)
    end

    context 'freeness_parameter_oms' do
      subject { create(:mapping, freeness_parameter_oms: create(:oms)) }
      it_behaves_like('it has a', :freeness_parameter_oms, OMS)
      it_behaves_like('being nullified with deletion of the association',
                      :freeness_parameter_oms)
    end

    context 'freeness_parameter_language' do
      subject do
        create(:mapping, freeness_parameter_language: create(:language))
      end
      it_behaves_like('it has a', :freeness_parameter_language, Language)
      it_behaves_like('being nullified with deletion of the association',
                      :freeness_parameter_language)
    end
  end
end
