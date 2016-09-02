Sequel.migration do
  change do

    create_table :repositories do
      primary_key :id
      String :name
      String :slug, index: :unique
      Text :description
      DateTime :created_at
      DateTime :updated_at
    end

  end
end