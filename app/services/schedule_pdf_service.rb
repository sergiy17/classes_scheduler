class SchedulePdfService
  def initialize(student)
    @student = student
  end

  def generate
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

    pdf.render
  end
end