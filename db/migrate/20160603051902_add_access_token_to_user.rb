class AddAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :text
    add_column :users, :industry, :string
    add_column :users, :headline, :text
    add_column :users, :summary, :text
    add_column :users, :picture_url, :text
    add_column :users, :last_name, :string
  end
end
