class QuestionFollow
  attr_accessor :user_id, :question_id, :id

  def initialize(attr = {})
    @user_id, @question_id = attr['user_id'], attr['question_id']
    @id = attr['id']
  end

  def self.find_by_id(id_lookup)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id_lookup)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    QuestionFollow.new(question_follow[0])
  end
end
