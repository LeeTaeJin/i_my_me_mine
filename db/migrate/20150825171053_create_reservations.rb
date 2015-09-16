class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      
      t.integer :room_id
      t.string :user
      t.string :professor
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.string :purpose
      t.string :state
      
      t.integer :real_id
            
      t.timestamps null: false
    end
  end
end
