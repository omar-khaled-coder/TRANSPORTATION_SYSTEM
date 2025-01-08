class DriversTruckSerializer
  include JSONAPI::Serializer

  attributes :assigned_date
  belongs_to :truck
end
