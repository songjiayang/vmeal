class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name, :default => ""
      t.string :short_name, :default=>""   
      t.timestamps
    end
  end
end
