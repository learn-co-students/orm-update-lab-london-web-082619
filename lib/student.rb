require_relative "../config/environment.rb"

class Student
   attr_accessor :name, :grade
   attr_reader :id
  def initialize (name, grade, id = nil)
    @name = name 
    @grade = grade
    @id = id 
    
  end
   
  #creates a table for student in database 

   def self.create_table
     sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
    
   end
   #boiler plate drops the students table from the database
   def self.drop_table 
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
   end

   #use boiler plate
   #updates a record if called on ab object that already persisted.
   #saves an instance of the student class to the database and the nsets the given students id attribute
   def save
    if self.id()
      self.update()
    else
    sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
   #use boiler plate udpate 

  def update 
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?;
  SQL

  DB[:conn].execute(sql, self.name, self.grade, self.id)
end

# create new student name with attributes method
def self.create(name, grade)
  new_student = self.new(name, grade)
  new_student.save 
  new_student
end


#creates an instance with corresponding attribute values
def self.new_from_db(row)
  #assign a variable then do .new(argument) 
  new_student = Student.new(row[1],row[2],row[0]) #mentioned in initialize so add it in the same order
  new_student #return student.
  end


#boiler plate sql 
# use new_from_db (DB ... boiler plate and add (sql and name in argument)[0])
def self.find_by_name(name)
  sql = <<-SQL
  SELECT * FROM students
  WHERE name = ?
  LIMIT 1
SQL
#given instance
new_from_db(DB[:conn].execute(sql, name)[0])
end

end


