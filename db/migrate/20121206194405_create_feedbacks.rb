class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.integer :user_id
      t.boolean :keep
      t.text :body

      t.timestamps
    end
  end
end
