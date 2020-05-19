class ChangeDatatypeNoteNameOfTunings < ActiveRecord::Migration[5.2]
  def change
    change_column :tunings, :note_name, :string
  end
end
