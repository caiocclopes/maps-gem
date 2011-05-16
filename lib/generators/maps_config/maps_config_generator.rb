# Use this generator like this:
# rails g maps_config

class MapsConfigGenerator < Rails::Generators::Base

  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def generate_scaffold
    generate("scaffold", "maps_config area_id:integer address:string number:integer city:string state:string zip:string name:string address:string info:text ")
    remove_file "./app/models/maps_config.rb"
    remove_file "./app/views/maps_configs/_form.html.erb"
    template "maps_config_model.rb", "./app/models/maps_config.rb"
    template "maps_config_iPhone.rb", "./app/controllers/maps_controller.rb"
    copy_file "maps_config_form.html.erb", "./app/views/maps_configs/_form.html.erb"
  end
end