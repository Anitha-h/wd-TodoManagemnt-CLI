require "date"
require "active_record"
due_date = Date.today

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date

    "#{id} #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"
    puts "Overdue\n"
    puts Todo.where("due_date < ?", Date.parse((Date.today).to_s)).to_displayable_list
    puts "\n\n"
    puts "Due Today\n"
    puts Todo.where("due_date = ?", Date.parse((Date.today).to_s)).to_displayable_list

    puts "\n\n"

    puts "Due Later\n"
    puts Todo.where("due_date > ?", Date.parse((Date.today).to_s)).to_displayable_list

    puts "\n\n"
  end
  def self.add_task(h)
    todo_text = h[:todo_text]
    due_in_days = h[:due_in_days]
    Todo.create!(todo_text: todo_text, due_date: Date.today + due_in_days)
  end
  def self.mark_as_complete(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
