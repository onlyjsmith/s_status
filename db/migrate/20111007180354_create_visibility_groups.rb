class CreateVisibilityGroups < ActiveRecord::Migration
  def change
    create_table :visibility_groups do |t|
      t.integer :user_id
      t.string :name
      t.string :skype_status
      t.string :real_status

      t.timestamps
    end
  end
end
