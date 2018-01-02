class SecretCode < ApplicationRecord
  belongs_to :user, required: false
  validates_uniqueness_of :code
  before_destroy :can_destroy?

  def self.generate(number_of_codes=10)
    count = 0
    while count < number_of_codes.to_i
      create!(code: unique_code)
      count += 1
    end
    count
  end

  def self.is_code_inuse?(code)
    records = where(code: code)
    return true if records.first.present? && records.first.user_id.present?
    false
  end

  private
  def self.unique_code
    loop do
      code = SecureRandom.hex(3)
      break code unless where(code: code).exists?
    end
  end

  def can_destroy?
    if user.present?
      errors.add(:base, 'cannot delete SecretCode that has an associated user')
      throw :abort
    end
  end
end
