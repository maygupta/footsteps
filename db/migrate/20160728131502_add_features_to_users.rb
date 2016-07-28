class AddFeaturesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maiden_name, :string
    add_column :users, :formatted_name, :string
    add_column :users, :phonetic_first_name, :string
    add_column :users, :phonetic_last_name, :string
    add_column :users, :formatted_phonetic_name, :string
    add_column :users, :num_connections, :integer
    add_column :users, :num_connections_capped, :integer
    add_column :users, :specialties, :text
    add_column :users, :public_profile_url, :text
    add_column :users, :last_modified_timestamp, :datetime
    add_column :users, :proposal_comments, :text
    add_column :users, :interests, :text
    add_column :users, :languages, :text
    add_column :users, :date_of_birth, :text
    add_column :users, :jid, :text
    add_column :users, :login_type, :string
    add_column :users, :gender, :string
    add_column :users, :bg_image_url, :text
    add_column :users, :presence_status, :string
    add_column :users, :is_mentor, :boolean
    add_column :users, :is_verified, :boolean
    add_column :users, :mentor_rating, :integer
    add_column :users, :normal_rating, :integer
  end
end
