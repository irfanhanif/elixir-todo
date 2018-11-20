defmodule Todo.Server do
  use GenServer

  def start(list_name) do
    GenServer.start(__MODULE__, list_name)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def terminate(pid) do
    GenServer.cast(pid, :terminate)
  end

  def init(list_name) do
    {:ok, {list_name, Todo.Database.get(list_name) || Todo.List.start}}
  end

  def handle_call({:get, key}, _from, {list_name, todo_list}) do
    new_todo_list = Todo.List.entries(todo_list, key)
    {:reply, new_todo_list, {list_name, new_todo_list}}
  end

  def handle_cast(:terminate, state) do
    {:stop, :normal, state}
  end

  def handle_cast({:put, key, value}, {list_name, todo_list}) do
    new_todo_list = Todo.List.add_entry(todo_list, key, value)
    Todo.Database.store(list_name, new_todo_list)
    {:noreply, {list_name, new_todo_list}}
  end
end