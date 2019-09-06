require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade


  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    # this creates a new Ruby object using attributes taken from a row of the database. Takes the array returned by the DB, which is a single row, and assigs the data to variables by selecting the right index.
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(name, grade, id)
  end

  def self.find_by_name(name)
    # this method queries the database using SQL, uses bound parameter placeholder in the SQL string, then in the .execute we pass it the name parameter. Then it invokes the CRITICAL helper method defined above, new_from_db, which reinstantiates objects into Ruby taking attribute data
    # supplied by the row in the database that matches the name of the student.
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end


  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      album TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save

    if self.id
      self.update

    else

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end
end

  def update
    sql = "UPDATE students SET name = ?, grade= ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end


  










end
