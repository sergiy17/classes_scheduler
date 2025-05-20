class StudentSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :sections, serializer: SectionSerializer
end