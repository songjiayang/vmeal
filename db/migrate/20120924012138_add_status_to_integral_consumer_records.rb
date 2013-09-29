class AddStatusToIntegralConsumerRecords < ActiveRecord::Migration
  def change
    add_column :integral_consumer_records, :status, :integer ,:default => 0
  end
end
