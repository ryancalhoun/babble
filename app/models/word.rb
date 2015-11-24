class Word < ActiveRecord::Base
  validates_uniqueness_of :value

  scope :not_punct, -> { where.not(:punct => true) }

  def self.get_random_word
    return unless count > 0
    min_id = not_punct.minimum(:id).to_i
    max_id = not_punct.maximum(:id).to_i

    not_punct.where(['id >= ?', min_id + rand(max_id - min_id + 1)]).first
  end
end
