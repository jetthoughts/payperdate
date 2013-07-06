class EnableHstore < ActiveRecord::Migration
  def up
    connection.execute 'CREATE EXTENSION IF NOT EXISTS hstore'
  end

  def down
    connection.execute 'DROP EXTENSION IF EXISTS hstore'
  end
end
