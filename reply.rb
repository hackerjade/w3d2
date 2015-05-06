class Reply < Table
  def self.find_by_id(id_lookup)
    return nil if id_lookup.nil?

    reply = QuestionsDatabase.instance.execute(<<-SQL, id_lookup)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(reply[0])
  end

  def self.find_child_replies(parent_id_lookup)
    replies = QuestionsDatabase.instance.execute(<<-SQL, parent_id_lookup)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    all_replies = []
    replies.each do |reply|
      all_replies << Reply.new(reply)
    end

    all_replies
  end

  def self.find_by_user_id(user_id_lookup)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id_lookup)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    user_replies = []
    replies.each do |reply|
      user_replies << Reply.new(reply)
    end

    user_replies
  end

  def self.find_by_question_id(question_id_lookup)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id_lookup)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    question_replies = []
    replies.each do |reply|
      question_replies << Reply.new(reply)
    end

    question_replies
  end

  attr_accessor :question_id, :parent_id, :user_id, :reply_body, :id

  def initialize(attr = {})
    @question_id, @parent_id = attr['question_id'], attr['parent_id']
    @user_id, @reply_body =  attr['user_id'], attr['reply_body']
    @id = attr['id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def child_replies
    Reply.find_child_replies(@id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def save
    attrs = [self.question_id, self.parent_id, self.user_id, self.reply_body]
    if !self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *attrs, @id)
        UPDATE
          replies
        SET
          question_id = ?,
          parent_id = ?,
          user_id = ?,
          reply_body = ?
        WHERE
          id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, *attrs)
        INSERT INTO
          replies (question_id, parent_id, user_id, reply_body)
        VALUES
          (?, ?, ?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
