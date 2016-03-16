class AddIsStickyToMicropost < ActiveRecord::Migration
  def change
  	add_column :microposts, :is_sticky, :boolean, :default => false
  end
end
