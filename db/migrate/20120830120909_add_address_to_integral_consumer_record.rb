class AddAddressToIntegralConsumerRecord < ActiveRecord::Migration
  def change
    add_column :integral_consumer_records, :address, :string
    add_column :integral_consumer_records, :phone, :string
    add_column :integral_consumer_records, :phone_bk, :string
    add_column :integral_consumer_records, :name, :string
  end
end
