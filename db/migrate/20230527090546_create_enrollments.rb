class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.belongs_to :batch
      t.belongs_to :user
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
