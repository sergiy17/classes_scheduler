class StudentsController < ApplicationController
  before_action :set_student, only: [:add_section, :remove_section, :schedule_pdf]

  def show
    student = Student.includes(sections: [:subject, :teacher, :classroom]).find_by(id: params[:id])

    if student
      render json: student, serializer: StudentSerializer
    else
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  def add_section
    section = Section.find_by(id: params[:section_id])

    if @student.add_section(section) && section
      render json: { message: "Section added successfully" }, status: :ok
    else
      render json: { error: "Cannot add section" }, status: :unprocessable_entity
    end
  end

  def remove_section
    section = @student.sections.find_by(id: params[:section_id])

    if @student.remove_section(section)
      render json: { message: "Section removed successfully" }, status: :ok
    else
      render json: { error: "Cannot remove selection" }, status: :unprocessable_entity
    end
  end

  def schedule_pdf
    pdf = Prawn::Document.new
    pdf.text "Schedule for #{@student.name}", size: 20, style: :bold
    pdf.move_down 20

    @student.schedule.each do |section|
      pdf.text "Subject: #{section.subject.name}"
      pdf.text "Time: #{section.start_time.strftime('%I:%M %p')} - #{section.end_time.strftime('%I:%M %p')}"
      pdf.text "Days: #{section.days.join(', ')}"
      pdf.text "Teacher: #{section.teacher.name}"
      pdf.text "Classroom: #{section.classroom.name}"
      pdf.move_down 10
    end

    send_data pdf.render, filename: "#{@student.name}_schedule.pdf", type: 'application/pdf', disposition: 'inline'
  end

  private

  def set_student
    @student = Student.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Student not found" }, status: :not_found
  end
end