class DataSheetSerializer < ActiveModel::Serializer
  attributes :id, :sheet_name, :created_at, :updated_at
end