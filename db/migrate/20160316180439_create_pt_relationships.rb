class CreatePtRelationships < ActiveRecord::Migration
  def change
    create_table :pt_relationships do |t|
    	t.timestamps null: false
      t.references :micropost, index: true, foreign_key: true
      t.references :topic, index: true, foreign_key: true
    end

    add_index :pt_relationships, [:micropost_id, :topic_id], unique: true
  end
end
