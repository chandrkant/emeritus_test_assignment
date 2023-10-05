class CreateSchools < ActiveRecord::Migration[6.1]
  def change
    create_table :schools do |t|
      t.string :name, limit: 100
      t.string :code, limit: 10
      t.string :description
      t.string :street
      t.string :city, limit: 100
      t.string :country, limit: 100
      t.belongs_to :user #belongs_to is actually an alias of references

      t.timestamps
    end
  end
end
