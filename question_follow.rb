class QuestionFollow < Table
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

  def self.followed_questions_for_user_id(user_id_lookup)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id_lookup)
    SELECT
      questions.*
    FROM
      question_follows
    INNER JOIN
      users ON users.id = question_follows.user_id
    INNER JOIN
      questions ON questions.id = question_follows.question_id
    WHERE
      users.id = ?
    SQL

    all_questions = []
    questions.each do |question|
      all_questions << Question.new(question)
    end

    all_questions
  end

  # refactor these long methods?
  def self.followers_for_question_id(question_id_lookup)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id_lookup)
    SELECT
      users.*
    FROM
      question_follows
    INNER JOIN
      users ON users.id = question_follows.user_id
    INNER JOIN
      questions ON questions.id = question_follows.question_id
    WHERE
      questions.id = ?
    SQL

    all_followers = []
    followers.each do |follower|
      all_followers << User.new(follower)
    end

    all_followers
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      question_follows
    INNER JOIN
      users ON users.id = question_follows.user_id
    INNER JOIN
      questions ON questions.id = question_follows.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT
      ?
    SQL

    top_questions = []
    questions.each do |question|
      top_questions << Question.new(question)
    end

    top_questions
  end

  attr_accessor :user_id, :question_id, :id

  def initialize(attr = {})
    @user_id, @question_id = attr['user_id'], attr['question_id']
    @id = attr['id']
  end

  def save
    attrs = [self.user_id, self.question_id]
    if !self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *attrs, @id)
        UPDATE
          question_follows
        SET
          user_id = ?,
          question_id = ?
        WHERE
          id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, *attrs)
        INSERT INTO
          question_follows (user_id, question_id)
        VALUES
          (?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
