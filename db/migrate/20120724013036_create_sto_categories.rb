class CreateStoCategories < ActiveRecord::Migration
  def change
    create_table :sto_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
