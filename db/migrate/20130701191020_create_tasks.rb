class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.references :list

      t.timestamps
    end
    add_index :tasks, :list_id
  end
end
