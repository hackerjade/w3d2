require 'singleton'
require 'sqlite3'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'question_like'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
  # def self.execute(*arg, &blk)
  #   self.instance.execute(arg, &blk)
  # end
end

if __FILE__ == $PROGRAM_NAME
  # u1 = User.find_by_id(1)
  # u2 = User.find_by_id(2)
  # u3 = User.find_by_id(3)
  # q1 = Question.find_by_id(1)
  # q2 = Question.find_by_id(2)
  # q3 = Question.find_by_id(3)
  # q4 = Question.find_by_id(4)
  # qf1 = QuestionFollow.find_by_id(1)
  r1 = Reply.find_by_id(1)
  r2 = Reply.find_by_id(2)
  r3 = Reply.find_by_id(3)
  r4 = Reply.find_by_id(4)
  p r1.child_replies
  # p r1.parent_id
  # p r2.parent_id
  # p r3.parent_id
  # p r4.parent_id
  # p r1.parent_reply
  # p r2.parent_reply
  # p r3.parent_reply
  # p r4.parent_reply
end
