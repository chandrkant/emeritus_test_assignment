class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name, limit: 100
      t.string :code, limit: 10
      t.integer :duration

      t.timestamps
    end
  end
end
