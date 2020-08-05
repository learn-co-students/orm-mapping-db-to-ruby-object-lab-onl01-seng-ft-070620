require 'pry'
class Student
  attr_accessor :id, :name, :grade

  # take a row from the database and turn it into a Student object
  # returns the Student object
  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  # retrieves all rows from the students database
  # create a new Student object for each row
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # find a student in the database, given their name
  # return that student's instance
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # returns an array of all students in grade 9
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of all students in grades 11 or below
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of the first x students in grade 10
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end

  # returns the first student (object) in grade 10
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  # returns an array of all students in grade x
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL

    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
