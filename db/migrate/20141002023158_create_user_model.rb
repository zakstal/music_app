class CreateUserModel < ActiveRecord::Migration
  def change
    create_table :user_models do |t|
    	t.string :email, null: false
    	t.string :password_digest, null: false
    	t.string :session_token, null: false	
    end

    add_index :user_models, :email, unique: true
    add_index :user_models, :session_token
  end
end
