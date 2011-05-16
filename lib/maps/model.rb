module Maps
  module Model
    
    class MapsModel
      include Mongoid::Document
      field :address
      field :longitude, type: Float
      field :latitude, type: Float
      field :info
      field :number, type: Integer
      field :city
      field :state
      field :zip
      field :localizated, type: Boolean, :default => false
      field :name, :default => "Unknown"
      field :area_id, type: Integer
      validates_presence_of :area_id, :message => "can`t be null"
      validates_uniqueness_of :area_id, :message => "must be unique"
      validates_presence_of :address, :message => "can`t be null"
      validates_presence_of :number, :message => "can`t be null"
      validates_presence_of :city, :message => "can`t be null"
  end
  
  end
end