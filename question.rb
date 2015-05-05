class Question
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

  attr_accessor :title, :body, :author_id, :id

  def initialize(attr = {})
    @title, @body = attr['title'], attr['body']
    @author_id, @id =  attr['author_id'], attr['id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end
