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

  many_to_one :file_version

  def validate
    validates_presence :loc_id
    super
  end
end
