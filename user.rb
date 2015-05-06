require_relative 'table'

class User < Table
  def self.find_by_id(id_lookup)
    user = QuestionsDatabase.instance.execute(<<-SQL, id_lookup)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(user[0])
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(user[0])
  end

  attr_accessor :fname, :lname, :id

  def initialize(attr = {})
    @fname, @lname, @id = attr['fname'], attr['lname'], attr['id']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def average_karma
    QuestionLike.average_karma(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end



  # def save
  #   attrs = [self.fname, self.lname]
  #   if !self.id.nil?
  #     QuestionsDatabase.instance.execute(<<-SQL, *attrs, @id)
  #       UPDATE
  #         users
  #       SET
  #         fname = ?,
  #         lname = ?
  #       WHERE
  #         id = ?
  #     SQL
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, *attrs)
  #       INSERT INTO
  #         users (fname, lname)
  #       VALUES
  #         (?, ?)
  #     SQL
  #
  #     @id = QuestionsDatabase.instance.last_insert_row_id
  #   end
  # end
end
