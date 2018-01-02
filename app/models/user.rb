class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :secret_code, dependent: :nullify
  has_and_belongs_to_many :roles
  validate :valid_secret_code

  def valid_secret_code
    if self.secret_code.blank?
      errors.add(:secret_code, 'is required')
    elsif SecretCode.is_code_inuse?(self.secret_code.code)
      errors.add(:secret_code, 'is already been taken')
    end
  end

  def admin?
    roles.map(&:name).include?('admin')
  end
end
