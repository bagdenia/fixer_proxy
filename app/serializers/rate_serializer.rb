class RateSerializer < ActiveModel::Serializer
  attributes :base, :other, :date, :rate
end
