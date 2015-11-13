class Chain < ActiveRecord::Base
  #validates_uniqueness_of :word, :scope => :previous
  validates :word, :uniqueness => { :scope => :previous }
end
