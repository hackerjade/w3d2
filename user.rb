class User
  attr_accessor :fname, :lname, :id

  def initialize(attr = {})
    @fname, @lname, @id = attr['fname'], attr['lname'], attr['id']
  end

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
  end
end
