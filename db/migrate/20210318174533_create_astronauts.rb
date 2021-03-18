class CreateAstronauts < ActiveRecord::Migration[5.2]
  def change
    create_table :astronauts do |t|

      t.timestamps
    end
  end
end
