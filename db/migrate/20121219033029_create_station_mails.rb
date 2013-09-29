class CreateStationMails < ActiveRecord::Migration
  def change
    create_table :station_mails do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
