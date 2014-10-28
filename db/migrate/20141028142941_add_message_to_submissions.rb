class AddMessageToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :message, :string
    add_column :submissions, :backtrace, :text
  end
end
