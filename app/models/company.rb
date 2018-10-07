class Company < ApplicationRecord
  belongs_to :admin, class_name: 'User', optional: true
  has_many :ratings

  def get_overal_rating
    ratings = self.ratings
    data = {}
    ratings.each do |rating|
      rating.columns.each do |column|
        data[column] = [] if !data[column]
        data[column] << rating[column] if rating[column]
      end
    end
    data = data.map{|k,v| [k,v.sum.to_f/v.count]}.select{|x| !x[1].to_f.nan?}.to_h
    if data.values.count != 0
      rating = data.values.sum/data.values.count
    else
      rating = 'Not yet rated'
    end
    return rating
  end
end
