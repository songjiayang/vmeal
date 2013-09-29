#encoding: utf-8
class ScoreHistories < ActiveRecord::Base
  attr_accessible :activity_id, :change_score, :change_type, :detail, :user_id, :operate
  TYPE=["[微大学]签到","[微大学]订餐评论","[微大学]幸运抽奖"]
  belongs_to :activity
end
