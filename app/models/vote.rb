# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  points        :integer          default(1)
#  voteable_type :string
#  voteable_id   :integer
#  user_id       :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Vote < ActiveRecord::Base

  belongs_to :voteable, :polymorphic => true
  belongs_to :user
  after_create :increment_points_cache

  validates :voteable_id, uniqueness: { scope: [:user_id, :voteable_type] }

  protected

  def increment_points_cache

    self.voteable_type.constantize.find(self.voteable_id).tap do |model|
      model.points += self.points
    end.save

  rescue
    logger.info("Could not increment cache")
  end


end
