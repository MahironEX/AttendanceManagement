class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.datetime :record_time
      t.integer :status
    end
  end
end
