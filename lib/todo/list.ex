defmodule Todo.List do
  def start do
    HashDict.new
  end

  def add_entry(todo_list, date, title) do
    HashDict.update(todo_list, date, [title], fn (titles) -> [title | titles] end)
  end

  def entries(todo_list, date) do
    HashDict.get(todo_list, date, [])
  end
end