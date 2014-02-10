class TwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :user_name
      t.timestamps
    end
  end
end
