class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :company

  def columns
    columns = [:programs,
      :community_involvement,
      :misdemeanors,
      :average_wage,
      :employee_benefits,
      :background_checks,
      :finances,
      :discrimination,
      :hiring_process,
      :legality,
      :peer_relations,
      :management,
      :workload,
      :hr_cooperation,
      :work_conditions]
    end
end
