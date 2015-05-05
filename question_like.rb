class QuestionLike
  attr_accessor :user_id, :question_id, :id

  def initialize(attr = {})
    @user_id, @question_id = attr['user_id'], attr['question_id']
    @id = attr['id']
  end

  def self.find_by_id(id_lookup)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id_lookup)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    QuestionLike.new(question_like[0])
  end
end
