class Chain < ActiveRecord::Base
  validates :word, :uniqueness => { :scope => :previous }

end
