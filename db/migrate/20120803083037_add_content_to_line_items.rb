class AddContentToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :content, :string

  end
end
