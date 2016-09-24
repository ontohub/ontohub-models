Sequel.migration do
  change do

    create_table :users do
      primary_key :id
      String :display_name
      String :email
      String :encrypted_password
      String :secret
    end

  end
end
