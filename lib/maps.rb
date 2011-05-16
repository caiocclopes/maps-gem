require "rubygems"
require "maps/model"


module Maps
    class << self


      def getMaps (area)
        if(area.is_a? Numeric)
          return Maps::Model::MapsModel.where(area_id: area)
        else
          return nil
        end
      end


      def getAll
        return Maps::Model::MapsModel.all.entries
      end

    end
  end
  

