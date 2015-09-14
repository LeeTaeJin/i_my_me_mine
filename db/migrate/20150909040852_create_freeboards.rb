class CreateFreeboards < ActiveRecord::Migration
  def change
    create_table :freeboards do |t|

        t.integer :fb_user_id
        t.string :fb_title
        t.text   :fb_content
        # t.string :fb_password

      t.timestamps null: false
    end
  end
end
