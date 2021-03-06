# frozen_string_literal: true

Sequel.migration do
  up do
    # Create a trigger that increments the +number+ column for a given
    # +dependent_column+.
    # rubocop:disable Metrics/MethodLength
    def create_trigger_to_set_number(table, dependent_column)
      # rubocop:enable Metrics/MethodLength
      function = <<~SQL
        BEGIN
          NEW.number := (SELECT COALESCE(MAX(number),0) + 1 AS nextNumber
                        FROM #{table}
                        WHERE #{dependent_column} = NEW.#{dependent_column});
          RETURN NEW;
        END;
      SQL
      function_name = :"#{table}_next_number"
      drop_function(function_name, cascade: true, if_exists: true)
      create_function(function_name, function,
                      language: :plpgsql, returns: :trigger)
      create_trigger(table, :trg_set_number, function_name,
                     events: :insert,
                     each_row: true)
    end

    # rubocop:disable Metrics/MethodLength
    def create_trigger_to_delete_parent(child_table, parent_table)
      # rubocop:enable Metrics/MethodLength
      function = <<~SQL
        BEGIN
          DELETE FROM #{parent_table} WHERE id = OLD.id;
          RETURN OLD;
        END;
      SQL
      function_name =
        :"on_delete_from_#{child_table}_also_delete_from_#{parent_table}"
      drop_function(function_name, cascade: true, if_exists: true)
      create_function(function_name, function,
                      language: :plpgsql, returns: :trigger)
      create_trigger(child_table, :trg_delete_from_parent, function_name,
                     events: :delete,
                     each_row: true,
                     after: true)
    end

    # Enums are disabled because the Haskell SQL library "persistent", which
    # Hets uses, cannot read enumeration types from the database. As soon as
    # https://github.com/yesodweb/persistent/issues/264 is fixed, enums can be
    # used again. Until then, every enum is replaced by a String with collation
    # "C".  If more models that could use enums are added, add the accompanying
    # enums as well, but comment them out and leave a note about the enum type.
    # extension :pg_enum

    # create_enum :organizational_unit_kind_type,
    #   %w(User Organization)

    create_table :organizational_units do
      primary_key :id
      # Kind of record - for class table inheritance
      # This is actually a :organizational_unit_kind_type, but replaced by
      # String for compatibility reasons.
      column :kind, String, collate: '"C"', null: false

      column :slug, String, collate: '"C"', null: false, unique: true

      column :display_name, String, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # User is an OrganizationalUnit
    # create_enum :global_role,
    #   %w(admin user)

    create_table :users do
      primary_key :id
      foreign_key [:id], :organizational_units,
                  null: false, unique: true, on_delete: :cascade

      column :secret, String, null: true

      # Devise database authenticatable
      column :email, String, null: false, unique: true
      column :encrypted_password, String, null: false

      # Devise confirmable
      column :confirmation_token, String, null: true
      column :confirmed_at, DateTime, null: true
      column :confirmation_sent_at, DateTime, null: true
      column :unconfirmed_email, String, null: true

      # Devise recoverable
      column :reset_password_token, String, null: true
      column :reset_password_sent_at, DateTime, null: true

      # Devise lockable
      column :failed_attempts, Integer, null: true, default: 0
      column :unlock_token, String, null: true
      column :locked_at, DateTime, null: true

      # Devise trackable
      column :sign_in_count, Integer, null: true, default: 0
      column :current_sign_in_at, DateTime, null: true
      column :last_sign_in_at, DateTime, null: true
      # Devise requires these columns to be set, but we don't want to store the
      # IP addresses in the database. We define empty getters/setters in the
      # model for these attributes:
      # column :current_sign_in_ip, String
      # column :last_sign_in_ip, String

      # This is actually a :global_role, but replaced by String for
      # compatibility reasons.
      column :role, String, collate: '"C"', null: false, default: 'user'
    end

    create_table :public_keys do
      primary_key :id
      foreign_key :user_id, :users,
                  null: false, index: true, on_delete: :cascade

      column :name, String, null: false
      column :key, String, null: false
      column :fingerprint, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:user_id, :name], null: false, unique: true
    end

    # Organization is a OrganizationalUnit
    create_table :organizations do
      primary_key :id
      foreign_key [:id], :organizational_units,
                  null: false, unique: true, on_delete: :cascade
      column :description, String, null: false
    end

    # create_enum :organization_role,
    #   %w(admin write read)

    create_table :organization_memberships do
      primary_key [:organization_id, :member_id]
      foreign_key :organization_id, :organizations,
                  null: false, index: true, on_delete: :cascade
      foreign_key :member_id, :users,
                  null: false, index: true, on_delete: :cascade
      # This is actually a :organization_role, but replaced by String for
      # compatibility reasons.
      column :role, String, collate: '"C"', null: false, default: 'read'
    end

    # create_enum :repository_content_type,
    #   %w(ontology model specification mathematical)

    # create_enum :repository_remote_type_type,
    #   %w(fork mirror)

    create_table :repositories do
      primary_key :id
      column :slug, String, collate: '"C"', null: false, unique: true
      foreign_key :owner_id, :organizational_units,
                  null: false, index: true, on_delete: :restrict

      column :name, String, null: false
      column :description, :text, null: true
      column :public_access, TrueClass, null: false
      # This is actually a :repository_content_type, but replaced by String for
      # compatibility reasons.
      column :content_type, String, collate: '"C"', null: false
      column :remote_address, String, null: true
      # This is actually a repository_remote_type_type, but replaced by String
      # for compatibility reasons.
      column :remote_type, String, collate: '"C"', null: true
      column :synchronized_at, DateTime, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # create_enum :api_key_kind_type,
    #   %w(GitShellApiKey HetsApiKey)

    create_table :api_keys do
      primary_key :id
      # Kind of record - for class table inheritance
      # This is actually a :api_key_kind_type, but replaced by String for
      # compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :key, String, null: false
      column :comment, String, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:kind, :key], null: false, unique: true
    end

    create_table :url_mappings do
      primary_key :id
      foreign_key :repository_id, :repositories,
                  null: false, index: true, on_delete: :cascade
      column :number, Integer, null: false # This is set by a trigger
      column :source, String, null: false
      column :target, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_trigger_to_set_number(:url_mappings, :repository_id)

    # create_enum :repository_role,
    #   %w(admin write read)

    create_table :repository_memberships do
      primary_key [:repository_id, :member_id]
      foreign_key :repository_id, :repositories,
                  null: false, index: true, on_delete: :cascade
      foreign_key :member_id, :users,
                  null: false, index: true, on_delete: :cascade
      # This is actually a :repository_role, but replaced by String for
      # compatibility reasons.
      column :role, String, collate: '"C"', null: false, default: 'read'
    end

    # create_enum :evaluation_state_type,
    #   %w(not_yet_enqueued enqueued processing
    #      finished_successfully finished_unsuccessfully)

    create_table :actions do
      primary_key :id, type: :bigserial
      # This is actually a :evaluation_state_type, but replaced by String for
      # compatibility reasons.
      column :evaluation_state, String,
             collate: '"C"',
             null: false,
             default: 'not_yet_enqueued'
      column :message, String, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_table :file_versions do
      primary_key :id, type: :bigserial

      foreign_key :repository_id, :repositories,
                  null: false, index: true, on_delete: :cascade

      foreign_key :action_id, :actions, null: false, on_delete: :restrict

      column :commit_sha, String, null: false
      column :path, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:repository_id, :commit_sha, :path], null: false, unique: true
    end

    create_table :file_version_parents do
      primary_key [:last_changed_file_version_id, :queried_sha]
      foreign_key :last_changed_file_version_id, :file_versions,
                  type: :bigint, null: false, on_delete: :cascade
      column :queried_sha, String, null: false, index: true
    end

    # create_enum :loc_id_base_kind_type,
    #   %w(NativeDocument Library OMS Mapping OpenConjecture Theorem
    #      CounterTheorem Axiom Symbol)

    create_table :loc_id_bases do
      # We use bigint/bigserial for the id because there will be many symbols
      # flooding this table for every version of every document file.
      primary_key :id, type: :bigserial
      foreign_key :file_version_id, :file_versions,
                  type: :bigint, null: false, on_delete: :cascade
      # Kind of record - for class table inheritance
      # This is actually a :loc_id_base_kind_type, but replaced by String for
      # compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :loc_id, String, collate: '"C"', null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:file_version_id, :kind, :loc_id], null: false, unique: true
    end

    # ##################################################################### #
    #                                                                       #
    #                            Managed by Hets                            #
    #                                                                       #
    # ##################################################################### #

    create_table :hets do
      column :key, String, null: false, primary_key: true
      column :value, String, null: false
    end

    create_table :languages do
      primary_key :id
      column :slug, String, collate: '"C"', null: false, unique: true
      column :name, String, null: false
      column :description, String, null: false
      column :standardization_status, String, null: false
      column :defined_by, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_table :logics do
      primary_key :id
      foreign_key :language_id, :languages,
                  null: false, on_delete: :cascade
      column :slug, String, collate: '"C"', null: false
      column :name, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:language_id, :slug], null: false, unique: true
    end

    create_table :serializations do
      primary_key :id
      foreign_key :language_id, :languages, null: false, on_delete: :cascade
      column :slug, String, collate: '"C"', null: false, unique: true
      column :name, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_table :language_mappings do
      primary_key :id
      foreign_key :source_id, :languages, null: false, on_delete: :cascade
      foreign_key :target_id, :languages, null: false, on_delete: :cascade

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:source_id, :target_id], null: false
    end

    create_table :logic_mappings do
      primary_key :id
      column :slug, String, collate: '"C"', null: false, unique: true

      foreign_key :language_mapping_id, :language_mappings,
                  null: false, on_delete: :cascade
      foreign_key :source_id, :logics, null: false, on_delete: :cascade
      foreign_key :target_id, :logics, null: false, on_delete: :cascade

      column :name, String, null: false
      column :is_inclusion, TrueClass, null: false
      column :has_model_expansion, TrueClass, null: false
      column :is_weakly_amalgamable, TrueClass, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:source_id, :target_id], null: false
    end

    create_table :logic_inclusions do
      primary_key :id
      column :slug, String, collate: '"C"', null: false, unique: true
      column :name, String, collate: '"C"', null: false, unique: true
      foreign_key :language_id, :languages, null: false, on_delete: :cascade
      foreign_key :source_id, :logics, null: false, on_delete: :cascade
      foreign_key :target_id, :logics, null: false, on_delete: :cascade

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger

      index [:source_id, :target_id], null: false
    end

    create_table :logic_translations do
      primary_key :id
      column :slug, String, collate: '"C"', null: false, unique: true
      column :name, String, collate: '"C"', null: false, unique: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_table :logic_translation_steps do
      primary_key :id
      foreign_key :logic_translation_id, :logic_translations,
                  null: false, on_delete: :cascade
      # This is *NOT* set by a trigger, but by Hets:
      column :number, Integer, null: false
      # Exactly one of these two fields is not null:
      foreign_key :logic_mapping_id, :logic_mappings,
                  null: true, on_delete: :cascade
      foreign_key :logic_inclusion_id, :logic_inclusions,
                  null: true, on_delete: :cascade

      index [:logic_translation_id, :number], unique: true
    end

    create_table :signatures do
      primary_key :id
      foreign_key :language_id, :languages, null: false, on_delete: :cascade
      column :as_json, String, null: false
    end

    create_table :signature_morphisms do
      primary_key :id
      foreign_key :logic_mapping_id, :logic_mappings,
                  null: false, on_delete: :cascade
      foreign_key :source_id, :signatures, null: false, on_delete: :cascade
      foreign_key :target_id, :signatures, null: false, on_delete: :cascade
      column :as_json, String, null: false
    end

    create_table :conservativity_statuses do
      primary_key :id
      column :required, String, null: false
      column :proved, String, null: false
    end

    # Document is a LocIdBase
    create_table :documents do
      primary_key :id, type: :bigserial
      foreign_key [:id], :loc_id_bases,
                  null: false, unique: true, on_delete: :cascade

      column :display_name, String, null: false
      column :name, String, null: false
      column :location, String, null: true
      column :version, String, null: true
    end

    create_table :document_links do
      primary_key :id, type: :bigserial
      foreign_key :source_id, :documents,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :target_id, :documents,
                  type: :bigint, null: false, on_delete: :cascade

      index [:source_id, :target_id], null: false
    end

    create_table :file_ranges do
      primary_key :id, type: :bigserial
      column :path, String, null: false
      column :start_line, Integer, null: false
      column :start_column, Integer, null: false
      column :end_line, Integer, null: true
      column :end_column, Integer, null: true
    end

    # create_enum :diagnosis_kind_type,
    #   %w(Error Warn Hint Debug)

    create_table :diagnoses do
      primary_key :id
      foreign_key :file_version_id, :file_versions,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :file_range_id, :file_ranges,
                  type: :bigint, null: true, on_delete: :set_null
      column :number, Integer, null: false # This is set by a trigger
      # This is actually a :diagnosis_kind_type, but replaced by String for
      # compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :text, String, null: false

      index [:file_version_id, :number], null: false, unique: true
    end

    create_trigger_to_set_number(:diagnoses, :file_version_id)

    # create_enum :oms_origin_type,
    #   %w(dg_empty dg_basic dg_basic_spec dg_extension dg_logic_coercion
    #      dg_translation dg_union dg_intersect dg_extract dg_restriction
    #      dg_reveal_translation free cofree np_free minimize dg_local dg_closed
    #      dg_logic_qual dg_data dg_formal_params dg_verification_generic
    #      dg_imports dg_inst dg_fit_spec dg_fit_view dg_proof dg_normal_form
    #      dg_integrated_scc dg_flattening dg_alignment dg_test)

    # CONSISTENCY_STAUSES = %w(Open Timeout Error Consistent Inconsistent)
    # create_enum :consistency_status_on_oms_type,
    #   [*CONSISTENCY_STAUSES, 'Contradictory']

    # OMS is a LocIdBase
    create_table :oms do
      primary_key :id, type: :bigserial
      foreign_key [:id], :loc_id_bases,
                  unique: true, on_delete: :cascade
      foreign_key :document_id, :documents,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :language_id, :languages, null: false, on_delete: :restrict
      foreign_key :logic_id, :logics, null: false, on_delete: :restrict
      foreign_key :signature_id, :signatures, null: false, on_delete: :restrict
      foreign_key :serialization_id, :serializations,
                  null: true, on_delete: :set_null
      foreign_key :normal_form_id, :oms,
                  type: :bigint, null: true, on_delete: :set_null
      foreign_key :normal_form_signature_morphism_id, :signature_morphisms,
                  null: true, on_delete: :set_null
      foreign_key :free_normal_form_id, :oms,
                  type: :bigint, null: true, on_delete: :set_null
      foreign_key :free_normal_form_signature_morphism_id, :signature_morphisms,
                  null: true, on_delete: :set_null
      foreign_key :conservativity_status_id, :conservativity_statuses,
                  null: false, on_delete: :cascade

      foreign_key :name_file_range_id, :file_ranges,
                  type: :bigint, null: true, on_delete: :set_null
      foreign_key :action_id, :actions, null: false, on_delete: :restrict
      # This is actually a :consistency_status_on_oms_type, but replaced by
      # String for compatibility reasons.
      column :consistency_status, String, collate: '"C"', null: false
      column :display_name, String, null: false
      column :name, String, null: false
      column :name_extension, String, null: false
      column :name_extension_index, Integer, null: false
      # The description is *not* managed by Hets
      column :description, String, null: true
      # This is actually a :oms_origin_type, but replaced by String for
      # compatibility reasons.
      column :origin, String, collate: '"C"', null: false
      column :label_has_hiding, TrueClass, null: false
      column :label_has_free, TrueClass, null: false
    end

    # create_enum :mapping_origin_type,
    #   %w(see_target see_source test dg_link_verif dg_implies_link
    #      dg_link_extension dg_link_translation dg_link_closed_lenv
    #      dg_link_imports dg_link_intersect dg_link_morph dg_link_inst
    #      dg_link_inst_arg dg_link_view dg_link_align dg_link_fit_view
    #      dg_link_fit_view_imp dg_link_proof dg_link_flattening_union
    #      dg_link_flattening_rename dg_link_refinement)

    # create_enum :mapping_type_type,
    #   %w(local_def local_thm_open local_thm_proved
    #      global_def global_thm_open global_thm_proved
    #      hiding_def
    #      free_def cofree_def np_free_def minimize_def
    #      hiding_open hiding_proved
    #      free_open cofree_open np_free_open minimize_open
    #      free_proved cofree_proved np_free_proved minimize_proved)

    create_table :mappings do
      primary_key :id, type: :bigserial
      foreign_key [:id], :loc_id_bases,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :source_id, :oms,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :target_id, :oms,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :signature_morphism_id, :signature_morphisms,
                  null: false, on_delete: :cascade
      # conservativity_status_id is only available on local_* and global_*
      # and cannot be null on these types
      foreign_key :conservativity_status_id, :conservativity_statuses,
                  null: true, on_delete: :set_null
      # freeness_parameter_*_id only available on
      # free_def, cofree_def, np_free_def, minimize_def
      # and exactly one of them is not null on these types
      foreign_key :freeness_parameter_oms_id, :oms,
                  type: :bigint, null: true, on_delete: :set_null
      foreign_key :freeness_parameter_language_id, :languages,
                  null: true, on_delete: :set_null
      column :display_name, String, null: false
      column :name, String, null: false
      # This is actually a :mapping_origin_type, but it is replaced by a String
      # for compatibility reasons.
      column :origin, String, collate: '"C"'
      # This is actually a :mapping_type_type, but it is replaced by a String
      # for compatibility reasons.
      column :type, String, collate: '"C"', null: false
      column :pending, TrueClass, null: false
    end

    # Sentence is a LocIdBase
    create_table :sentences do
      primary_key :id, type: :bigserial
      foreign_key [:id], :loc_id_bases,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :oms_id, :oms, type: :bigint, null: false, on_delete: :cascade
      foreign_key :file_range_id, :file_ranges,
                  type: :bigint, null: true, on_delete: :set_null
      foreign_key :original_sentence_id, :sentences,
                  type: :bigint, null: true, on_delete: :set_null
      column :name, String, null: false
      column :text, String, null: false
    end

    # PROOF_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS).freeze
    # create_enum :proof_status_on_conjecture_type,
    #   [*PROOF_STATUSES, 'CONTR']

    create_table :axioms do
      primary_key :id, type: :bigserial
      foreign_key [:id], :sentences,
                  null: false, unique: true, on_delete: :cascade
    end

    # Conjecture is a Sentence
    create_table :conjectures do
      primary_key :id, type: :bigserial
      foreign_key [:id], :sentences,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :action_id, :actions, null: false, on_delete: :restrict
      # This is actually a :proof_status_on_conjecture_type, but it is
      # replaced by a String for compatibility reasons.
      column :proof_status, String,
        collate: '"C"',
        null: false,
        default: 'OPN'
    end

    # Symbol is a LocIdBase
    create_table :symbols do
      primary_key :id, type: :bigserial
      foreign_key [:id], :loc_id_bases,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :oms_id, :oms, type: :bigint, null: false, on_delete: :cascade
      foreign_key :file_range_id, :file_ranges,
                  type: :bigint, null: true, on_delete: :set_null
      column :symbol_kind, String, null: false
      column :name, String, null: false
      column :full_name, String, null: false
    end

    create_table :symbol_mappings do
      primary_key :id
      foreign_key :signature_morphism_id, :signature_morphisms,
                  null: false, on_delete: :cascade
      foreign_key :source_id, :symbols, null: false, on_delete: :cascade
      foreign_key :target_id, :symbols, null: false, on_delete: :cascade
      index [:signature_morphism_id, :source_id, :target_id],
            null: false, unique: true
    end

    create_table :sentences_symbols do
      primary_key [:sentence_id, :symbol_id]
      foreign_key :sentence_id, :sentences,
                  type: :bigint, null: false, index: true, on_delete: :cascade
      foreign_key :symbol_id, :symbols,
                  type: :bigint, null: false, index: true, on_delete: :cascade
    end

    create_table :signature_symbols do
      primary_key [:signature_id, :symbol_id]
      foreign_key :signature_id, :signatures,
                  null: false, on_delete: :cascade
      foreign_key :symbol_id, :symbols,
                  type: :bigint, null: false, on_delete: :cascade
      column :imported, TrueClass, null: false
    end

    # create_enum :reasoner_kind_type,
    #   %w(Prover ConsistencyChecker)

    create_table :reasoners do
      primary_key :id
      column :slug, String, collate: '"C"', null: false
      # This is actually a :reasoner_kind_type, but it is replaced by
      # a String for compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :display_name, String, null: false, unique: true
      index [:slug, :kind], null: false, unique: true
    end

    create_table :reasoner_configurations do
      primary_key :id
      foreign_key :configured_reasoner_id, :reasoners,
                  null: true, on_delete: :set_null
      column :time_limit, Integer, null: true
    end

    # create_enum :reasoning_attempt_kind_type,
    #   %w(ProofAttempt ConsistencyCheckAttempt)

    # ReasoningAttempt is using Single Table Inheritance
    create_table :reasoning_attempts do
      primary_key :id
      foreign_key :reasoner_configuration_id, :reasoner_configurations,
                  null: false, on_delete: :cascade
      # There is no used logic_mapping until reasoning has begun.
      foreign_key :used_logic_translation_id, :logic_translations,
                  null: true, on_delete: :set_null
      # There is no used reasoner until reasoning has begun.
      foreign_key :used_reasoner_id, :reasoners,
                  null: true, on_delete: :set_null
      foreign_key :action_id, :actions, null: false, on_delete: :restrict
      # This is actually a :reasoning_attempt_kind_type, but it is replaced by
      # a String for compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :time_taken, Integer, null: true

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # create_enum :proof_status_on_proof_attempt_type, PROOF_STATUSES

    create_table :proof_attempts do
      primary_key :id
      foreign_key [:id], :reasoning_attempts,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :conjecture_id, :conjectures,
                  type: :bigint, null: true, on_delete: :cascade
      # This is actually a :proof_status_on_proof_attempt_type, but it
      # is replaced by a String for compatibility reasons.
      column :proof_status, String, collate: '"C"', null: false, default: 'OPN'
      column :number, Integer, null: false # This is set by a trigger
    end
    create_trigger_to_set_number(:proof_attempts, :conjecture_id)
    create_trigger_to_delete_parent(:proof_attempts, :reasoning_attempts)

    # create_enum :consistency_status_on_consistency_check_type,
    #   CONSISTENCY_STAUSES

    create_table :consistency_check_attempts do
      primary_key :id
      foreign_key [:id], :reasoning_attempts,
                  null: false, unique: true, on_delete: :cascade
      foreign_key :oms_id, :oms,
                  type: :bigint, null: true, on_delete: :cascade
      # This is actually a :consistency_status_on_consistency_check_type, but
      # replaced by String for compatibility reasons.
      column :consistency_status, String, collate: '"C"', null: false
      column :number, Integer, null: false # This is set by a trigger
    end
    create_trigger_to_set_number(:consistency_check_attempts, :oms_id)
    create_trigger_to_delete_parent(:consistency_check_attempts,
                                    :reasoning_attempts)

    create_table :proof_attempts_used_sentences do
      primary_key :id
      foreign_key :proof_attempt_id, :proof_attempts,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :sentence_id, :sentences,
                  type: :bigint, null: false, on_delete: :cascade
    end

    create_table :generated_axioms do
      primary_key :id
      foreign_key :reasoning_attempt_id, :reasoning_attempts,
                  null: false, on_delete: :cascade
      column :text, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    create_table :reasoner_outputs do
      primary_key :id
      foreign_key :reasoning_attempt_id, :reasoning_attempts,
                  null: false, on_delete: :cascade
      foreign_key :reasoner_id, :reasoners, null: false, on_delete: :cascade
      column :text, String, null: false

      column :created_at, DateTime, null: false # This is set by a trigger
      column :updated_at, DateTime, null: false # This is set by a trigger
    end

    # create_enum :premise_selection_kind_type,
    #   %w(ManualPremiseSelection SinePremiseSelection)

    create_table :premise_selections do
      primary_key :id
      foreign_key :reasoner_configuration_id, :reasoner_configurations,
                  null: false, on_delete: :cascade
      foreign_key :proof_attempt_id, :proof_attempts,
                  null: false, on_delete: :cascade
      # This is actually a :premise_selection_kind_type, but it is replaced by
      # a String for compatibility reasons.
      column :kind, String, collate: '"C"', null: false
      column :time_taken, Integer, null: true
    end

    create_table :premise_selected_sentences do
      primary_key [:premise_id, :premise_selection_id]
      foreign_key :premise_id, :sentences,
                  type: :bigint, null: false, index: true, on_delete: :cascade
      foreign_key :premise_selection_id, :premise_selections,
                  null: false, index: true, on_delete: :cascade
    end

    # ManualPremiseSelection is a PremiseSelection
    create_table :manual_premise_selections do
      primary_key :id
      foreign_key [:id], :premise_selections,
                  null: false, unique: true, on_delete: :cascade
    end

    # SinePremiseSelection is a PremiseSelection
    create_table :sine_premise_selections do
      primary_key :id
      foreign_key [:id], :premise_selections,
                  null: false, unique: true, on_delete: :cascade
      column :depth_limit, Integer, null: true
      column :tolerance, Float, null: false
      column :premise_number_limit, Integer, null: true
    end

    create_table :sine_symbol_premise_triggers do
      primary_key :id
      foreign_key :sine_premise_selection_id, :sine_premise_selections,
                  null: false, on_delete: :cascade
      foreign_key :premise_id, :sentences,
                  type: :bigint, null: false, on_delete: :cascade
      foreign_key :symbol_id, :symbols,
                  type: :bigint, null: false, on_delete: :cascade
      column :min_tolerance, Float, null: false
    end

    create_table :sine_symbol_commonnesses do
      primary_key :id
      foreign_key :sine_premise_selection_id, :sine_premise_selections,
                  null: false, on_delete: :cascade
      foreign_key :symbol_id, :symbols,
                  type: :bigint, null: false, on_delete: :cascade
      column :commonness, Integer, null: false
    end

    # ##################################################################### #
    #                                                                       #
    #               Triggers for automatic timestamp updates                #
    #                                                                       #
    # ##################################################################### #

    # Setup created_at and updated_at triggers to automatically set these column
    # values.
    # See https://github.com/jeremyevans/sequel_postgresql_triggers
    extension :pg_triggers

    tables.select { |table| self[table].columns.include?(:created_at) }.
      each do |table|
      pgt_created_at(table,
                     :created_at,
                     function_name: :"#{table}_set_created_at",
                     trigger_name: :set_created_at)
    end

    tables.select { |table| self[table].columns.include?(:updated_at) }.
      each do |table|
      pgt_updated_at(table,
                     :updated_at,
                     function_name: :"#{table}_set_updated_at",
                     trigger_name: :set_updated_at)
    end
  end
end
