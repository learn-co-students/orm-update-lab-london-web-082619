require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id

    @@all << self
  end
  

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def update(value = nil)
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if @id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
    self
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
    end

  def self.find_by_name(n)
    sql = <<-SQL 
    SELECT * FROM students 
    WHERE name = ? 
    LIMIT 1
    SQL
    DB[:conn].execute(sql, n).map { | record | self.new_from_db(record) }[0]
  end

  






end



  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


