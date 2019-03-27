class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :rsvp

      t.timestamps
    end
  end
end
