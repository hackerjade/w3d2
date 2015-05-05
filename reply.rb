class Reply
  attr_accessor :question_id, :parent_reply, :user_id, :reply_body, :id

  def initialize(attr = {})
    @question_id, @parent_reply = attr['question_id'], attr['parent_reply']
    @user_id, @reply_body =  attr['user_id'], attr['reply_body']
    @id = attr['id']
  end

  def self.find_by_id(id_lookup)
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
end
