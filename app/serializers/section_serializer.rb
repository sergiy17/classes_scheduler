class SectionSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :days, :subject, :teacher, :classroom

  belongs_to :subject
  belongs_to :teacher
  belongs_to :classroom

  def start_time
    object.start_time.strftime('%H:%M:%S') if object.start_time
  end

  def end_time
    object.end_time.strftime('%H:%M:%S') if object.end_time
  end
end