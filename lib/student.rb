require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER );"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (? , ? )"

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(array)
    new_student = self.new(array[0], array[1], array[2])
    new_student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"

    DB[:conn].execute(sql, name).map {|name| self.new_from_db(name)}.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
