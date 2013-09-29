class CreateVmealCategores < ActiveRecord::Migration
  def change
    create_table :vmeal_categores do |t|
      t.string :name
      t.timestamps
    end
  end
end
