class ChangeImageOnItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, default: "https://cateringbywestwood.com/wp-content/uploads/2015/11/dog-placeholder.jpg"
  end
end
