# frozen_string_literal: true

# Superclass of many classes inside a FileVersion
class LocIdBase < Sequel::Model
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind,
                                   alias: :loc_id_bases,
                                   table_map: {NativeDocument: :documents,
                                               Library: :documents,
                                               OMS: :oms,
                                               Mapping: :mappings,
                                               OpenConjecture: :conjectures,
                                               Theorem: :conjectures,
                                               CounterTheorem: :conjectures,
                                               Axiom: :axioms,
                                               OMSSymbol: :symbols},
                                   model_map: (lambda do |model|
                                                 if model == 'Symbol'
                                                   OMSSymbol.name
                                                 else
                                                   model
                                                 end
                                               end),
                                   key_map: (lambda do |klass|
                                               if klass == OMSSymbol
                                                 'Symbol'
                                               else
                                                 klass.name
                                               end
                                             end)

  dataset_module do
    # Query a LocIdBase model at a given version using the file_version_parents
    # table to find the actual file version of the model.
    def where_commit_sha(commit_sha:, **options)
      # Load all subclasses once (only useful in development mode) in order to
      # get the leafs of the subclass relation.
      _loc_id_base_classes =
        [NativeDocument, Library, OMS, Mapping, OpenConjecture, Theorem,
         CounterTheorem, Axiom, OMSSymbol]

      graph(:file_version_parents,
            {Sequel[:file_version_parents][:last_changed_file_version_id] =>
               Sequel[:loc_id_bases][:file_version_id]},
            select: false).
        where(options.merge(Sequel[:file_version_parents][:queried_sha] =>
                              commit_sha,
                            kind: subclass_leaf_keys([], model)))
    end

    private

    def subclass_leaf_keys(leafs, klass)
      if klass.subclasses.any?
        leafs + klass.subclasses.
          map { |subklass| subclass_leaf_keys([], subklass) }.flatten
      else
        [*leafs, LocIdBase.sti_key_map.call(klass)]
      end
    end
  end

  many_to_one :file_version

  def validate
    validates_presence :loc_id
    super
  end
end
