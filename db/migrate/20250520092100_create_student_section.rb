class CreateStudentSection < ActiveRecord::Migration[8.0]
  def change
    create_table :student_sections, force: :cascade do |t|
      t.bigint :student_id, null: false
      t.bigint :section_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:section_id], name: "index_student_sections_on_section_id"
      t.index [:student_id, :section_id], name: "index_student_sections_on_student_id_and_section_id", unique: true
    end

    add_foreign_key :student_sections, :students
    add_foreign_key :student_sections, :sections
  end
end
