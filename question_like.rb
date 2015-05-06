class QuestionLike < Table
  def self.average_karma(user_id_lookup)
    count = QuestionsDatabase.instance.execute(<<-SQL, user_id_lookup)
    SELECT
      CAST (
        COUNT(question_likes.user_id) AS FLOAT) /
      COUNT(DISTINCT(
      questions.title)) AS count
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      questions.author_id = ?
    SQL

    p count[0]["count"]
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

  def self.liked_questions_for_user_id(user_id_lookup)
    questions =  QuestionsDatabase.instance.execute(<<-SQL, user_id_lookup)
    SELECT
      questions.*
    FROM
      question_likes
    INNER JOIN
      users ON users.id = question_likes.user_id
    INNER JOIN
      questions ON questions.id = question_likes.question_id
    WHERE
      users.id = ?
    SQL

    all_questions = []
    questions.each do |question|
      all_questions << Question.new(question)
    end

    all_questions
  end

  def self.likers_for_question_id(question_id_lookup)
    likers =  QuestionsDatabase.instance.execute(<<-SQL, question_id_lookup)
    SELECT
      users.*
    FROM
      question_likes
    INNER JOIN
      users ON users.id = question_likes.user_id
    INNER JOIN
      questions ON questions.id = question_likes.question_id
    WHERE
      questions.id = ?
    SQL

    all_likers = []
    likers.each do |liker|
      all_likers << User.new(liker)
    end

    all_likers
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      question_likes
    INNER JOIN
      users ON users.id = question_likes.user_id
    INNER JOIN
      questions ON questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT
      ?
    SQL

    most_liked_questions = []
    questions.each do |question|
      most_liked_questions << Question.new(question)
    end

    most_liked_questions
  end

  def self.num_likes_for_question_id(question_id_lookup)
    count = QuestionsDatabase.instance.execute(<<-SQL, question_id_lookup)
    SELECT
      COUNT(*)
    FROM
      question_likes
    WHERE
      question_likes.question_id = ?
    SQL

    count[0]["COUNT(*)"]
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
          question_likes
        SET
          user_id = ?,
          question_id = ?
        WHERE
          id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, *attrs)
        INSERT INTO
          question_likes (user_id, question_id)
        VALUES
          (?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
