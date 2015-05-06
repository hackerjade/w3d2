require 'active_support/inflector'

class Table
  def save
    p attrs = make_attrs
    table = make_table

    if !self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, table, *attrs, @id)
        UPDATE
          '#{table}'
        SET
          ?,
          ?
        WHERE
          id = ?
      SQL
    # else
    #   QuestionsDatabase.instance.execute(<<-SQL, table, *attrs)
    #     INSERT INTO
    #       ? (fname, lname)
    #     VALUES
    #       (?, ?)
    #   SQL
    #
    #   @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  private
  def make_attrs
    attrs = self.instance_variables
    attrs.map! do |el|
      el = "#{el.to_s[1..-1]} = #{el.to_s[1..-1]}"
    end

    attrs
  end

  def make_table
    self.class.to_s.downcase.tableize
  end
end
