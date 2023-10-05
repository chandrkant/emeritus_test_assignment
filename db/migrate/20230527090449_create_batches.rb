class CreateBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :batches do |t|
      t.belongs_to :course
      t.belongs_to :school
      t.string :name, limit: 100
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
