class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :company, foreign_key: true
      t.integer :programs
      t.integer :community_involvement
      t.integer :misdemeanors
      t.integer :average_wage
      t.integer :employee_benefits
      t.integer :background_checks
      t.integer :finances
      t.integer :discrimination
      t.integer :hiring_process
      t.integer :legality
      t.integer :peer_relations
      t.integer :management
      t.integer :workload
      t.integer :hr_cooperation
      t.integer :work_conditions

      t.timestamps
    end
  end
end
