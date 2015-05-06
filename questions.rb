require 'singleton'
require 'sqlite3'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'question_like'
require_relative 'table'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

if __FILE__ == $PROGRAM_NAME
  u1 = User.find_by_id(3)
  p u1
  u1.fname = 'Taber'
  p u1
  u1.save
end
