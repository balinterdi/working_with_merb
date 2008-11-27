migration 1, :make_user_name_not_nullable  do
  up do
		modify_table :users do
			change_column :name, String, :nullable => false, :length => (2..100)
		end
  end

  down do
		modify_table :users do
			drop_column :name
		end
  end
end
