#encoding: utf-8
class ScoreHistories < ActiveRecord::Base
  TYPE=["[微大学]签到","[微大学]订餐评论","[微大学]幸运抽奖"]
  belongs_to :activity
end
