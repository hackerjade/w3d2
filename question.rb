class Question < Table
  def self.find_by_author_id(author_id_lookup)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id_lookup)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    author_questions = []
    questions.each do |question|
      author_questions << Question.new(question)
    end

    author_questions
  end

  def self.find_by_id(id_lookup)
    question = QuestionsDatabase.instance.execute(<<-SQL, id_lookup)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(question[0])
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :title, :body, :author_id, :id

  def initialize(attr = {})
    @title, @body = attr['title'], attr['body']
    @author_id, @id =  attr['author_id'], attr['id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def inspect
    {t: @title}.inspect
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def save
    attrs = [self.title, self.body, self.author_id]
    if !self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *attrs, @id)
        UPDATE
          questions
        SET
          title = ?,
          body = ?,
          author_id = ?
        WHERE
          id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, *attrs)
        INSERT INTO
          questions (title, body, author_id)
        VALUES
          (?, ?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
