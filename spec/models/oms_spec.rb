# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OMS do
  context 'superclass' do
    subject { build(:oms) }
    it_behaves_like 'a loc_id_base'
  end

  context 'associations' do
    subject { create(:oms) }

    context 'document' do
      it_behaves_like('it has a', :document, Document)
      it_behaves_like('being deleted with the association', :document)
    end

    context 'language' do
      it_behaves_like('it has a', :language, Language)
      it_behaves_like('restricting the deletion of the association', :language)
    end

    context 'logic' do
      it_behaves_like('it has a', :logic, Logic)
      it_behaves_like('restricting the deletion of the association', :logic)
    end

    context 'signature' do
      it_behaves_like('it has a', :signature, Signature)
      it_behaves_like('restricting the deletion of the association', :signature)
    end

    context 'serialization' do
      context 'blank' do
        before do
          subject.serialization_id = nil
          subject.save
        end

        it 'is nil' do
          expect(subject.serialization).to be(nil)
        end
      end

      context 'present' do
        it_behaves_like('it has a', :serialization, Serialization)
        it_behaves_like('being nullified with deletion of the association',
                        :serialization)
      end
    end

    context 'normal_form' do
      context 'blank' do
        it 'is nil' do
          expect(subject.normal_form).to be(nil)
        end
      end

      context 'present' do
        subject { create(:oms, :with_normal_form) }

        it_behaves_like('it has a', :normal_form, OMS)
        it_behaves_like('being nullified with deletion of the association',
                        :normal_form)
      end
    end

    context 'normal_form_signature_morphism' do
      context 'blank' do
        it 'is nil' do
          expect(subject.normal_form_signature_morphism).to be(nil)
        end
      end

      context 'present' do
        subject { create(:oms, :with_normal_form) }

        it_behaves_like('it has a', :normal_form_signature_morphism,
                        SignatureMorphism)
        it_behaves_like('being nullified with deletion of the association',
                        :normal_form_signature_morphism)
      end
    end

    context 'free_normal_form' do
      context 'blank' do
        it 'is nil' do
          expect(subject.free_normal_form).to be(nil)
        end
      end

      context 'present' do
        subject { create(:oms, :with_free_normal_form) }

        it_behaves_like('it has a', :free_normal_form, OMS)
        it_behaves_like('being nullified with deletion of the association',
                        :free_normal_form)
      end
    end

    context 'free_normal_form_signature_morphism' do
      context 'blank' do
        it 'is nil' do
          expect(subject.free_normal_form_signature_morphism).to be(nil)
        end
      end

      context 'present' do
        subject { create(:oms, :with_free_normal_form) }

        it_behaves_like('it has a', :free_normal_form_signature_morphism,
                        SignatureMorphism)
        it_behaves_like('being nullified with deletion of the association',
                        :free_normal_form_signature_morphism)
      end
    end

    context 'conservativity_status' do
      it_behaves_like('it has a', :conservativity_status, ConservativityStatus)
      it_behaves_like('being deleted with the association',
                      :conservativity_status)
    end

    context 'mappings' do
      let!(:as_source) { create(:mapping, source: subject) }
      let!(:as_target) { create(:mapping, target: subject) }
      let!(:unrelated) { create(:mapping) }

      context 'mappings_source' do
        it 'contains the mapping' do
          expect(subject.mappings_by_source).to match_array([as_source])
        end
      end

      context 'mappings_target' do
        it 'contains the mapping' do
          expect(subject.mappings_by_target).to match_array([as_target])
        end
      end

      context 'mappings' do
        it 'contains the mappings' do
          expect(subject.mappings).to match_array([as_source, as_target])
        end
      end
    end

    it_behaves_like 'having a file_range', :name_file_range

    shared_examples 'having many' do |association, factory|
      let!(:related) { create_list(factory, 2, oms: subject) }
      let!(:unrelated) { create_list(factory, 2) }

      it 'contains the related objects' do
        expect(subject.public_send(association)).to match_array(related)
      end
    end

    it_behaves_like 'having many',
      :consistency_check_attempts, :consistency_check_attempt

    it_behaves_like 'having many', :sentences, :axiom
    it_behaves_like 'having many', :axioms, :axiom
    it_behaves_like 'having many', :conjectures, :open_conjecture
    it_behaves_like 'having many', :open_conjectures, :open_conjecture
    it_behaves_like 'having many', :theorems, :theorem
    it_behaves_like 'having many', :counter_theorems, :counter_theorem
  end
end
