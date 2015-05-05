class Question
  attr_accessor :title, :body, :author, :id

  def initialize(attr = {})
    @title, @body = attr['title'], attr['body']
    @author, @id =  attr['author'], attr['id']
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
end
