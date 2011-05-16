require "geokit"

class MapsController < ApplicationController
  
  def setLatLong

        # define as coordenadas geograficas para cada endereço
       posicao = 0 
       cursor = Maps.getAll[posicao]

        while cursor != nil # enquanto houver registros
          if !cursor.localizated
       begin 
         coordenadas = Geokit::Geocoders::MultiGeocoder.geocode(cursor.address + " " + cursor.number.to_s + " " + cursor.zip + " " + cursor.city + " " + cursor.state)
          cursor.latitude = coordenadas.lat
          cursor.longitude = coordenadas.lng
          cursor.localizated = true
          cursor.save
        rescue
          end  
        
        end
          posicao += 1 # posicao++
          cursor = Maps.getAll[posicao]
    end
  end
  
  
  def getMaps
       
       
        # retorna as configurações padrão
        setLatLong()
    if(params[:area_id] == nil)
     cursor = Maps.getAll
    else
     cursor = Maps.getMaps(params[:area_id].to_i)
    end
    if(cursor != nil)
      if(cursor.entries.count == 1)
        render :text => cursor.entries.first.to_json
      else
        render :text => cursor.entries.to_json
      end
    else
      render :text => {:success => false}.to_json
    end
  end
  
  
  
  def getStores
    
    
    if(params[:max_inicial_lat] == nil or params[:max_inicial_lng] == nil or params[:min_inicial_lat] == nil or params[:min_inicial_lng] == nil or params[:max_final_lat] == nil or params[:max_final_lng] == nil or params[:min_final_lat] == nil or params[:min_final_lng] == nil)
      render :text => "Error - missing parameters"
      return
    end
    
  stores = Maps::Model::MapsModel.where(:latitude.lte => params[:max_final_lat].to_f).where(:latitude.gte => params[:min_final_lat].to_f).where(:longitude.lte => params[:max_final_lng].to_f).where(:longitude.gte => params[:min_final_lng].to_f)
  
  if(params[:max_inicial_lat] == 0.00000 or params[:max_inicial_lng] == 0.00000 or params[:min_inicial_lat] == 0.00000 or params[:min_inicial_lng] == 0.00000  or params[:max_final_lat] == 0.00000  or params[:max_final_lng] == 0.00000 or params[:min_final_lat] == 0.00000  or params[:min_final_lng] == 0.00000 )
    render :text => stores.entries.to_json
  else
    stores_not = Maps::Model::MapsModel.where(:latitude.lte => params[:max_inicial_lat].to_f).where(:latitude.gte => params[:min_inicial_lat].to_f).where(:longitude.lte => params[:max_inicial_lng].to_f).where(:longitude.gte => params[:min_inicial_lng].to_f)
    stores = (stores.entries - stores_not.entries)
    render :text => stores.entries.to_json
    end
  end
  
  
  
  def getCloser
    if(params[:lat] == nil or params[:lng] == nil )
      render :text => "Error - missing parameters"
     return
    end
    found = false
  precision = 0.0000001
    
    while !found
    
   stores = Maps::Model::MapsModel.where(:latitude.lte => (params[:lat].to_f + precision)).where(:latitude.gte => (params[:lat].to_f - precision)).where(:longitude.lte => (precision + params[:lng].to_f)).where(:longitude.gte => ( params[:lng].to_f - precision))
    
   if stores.first == nil
      precision = 5 * precision
    else
      found = true
    end
  end
  if(stores.entries.count == 1)
    render :text => stores.entries.first.to_json
    return
  else
    posicao = 0
   
    d = ((params[:lat].to_f - stores.first.latitude)**2 + (params[:lng].to_f - stores.first.longitude)**2 )**0.5
    area_menor = stores.first.area_id
    
   while stores[posicao] != nil
    d1 = ((params[:lat].to_f - stores[posicao].latitude)**2 + (params[:lng].to_f - stores[posicao].longitude)**2)**0.5 
    if (d1 < d)
      d = d1
      area_menor = stores[posicao].area_id
    end
   posicao += 1   
 end
 end
 render :text => (Maps::Model::MapsModel.where(area_id: area_menor)).entries.to_json
end
    
    
  def create
   
    maps_config = MapsModel.new
    maps_config.address = params[:address]
    maps_config.area_id = params[:area_id].to_i
    maps_config.name = params[:name]
    maps_config.number = params[:number].to_i
    maps_config.city = params[:city]
    maps_config.zip = params[:zip]
    
    if maps_config.save  
      render :text => {:success => true}.to_json
    else
      render :text => {:success => false}.to_json
    end
  end
  
  
end