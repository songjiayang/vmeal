class AddNumberToSuperMan < ActiveRecord::Migration
  def change
    add_column :super_men, :number, :string

  end
end
