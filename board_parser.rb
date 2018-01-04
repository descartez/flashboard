require 'yaml'

module BoardParser
  def self.load(file)
    @board_config = YAML::load_file(file)
    @place_name = @board_config['place_name']
    @intro_message = @board_config['place_lead']
    @announcements = @board_config['announcements']
  end

  def self.save(params, file)
    @place_name = params.fetch(:place_name)
    @intro_message = params.fetch(:place_lead)
    @announcements = params.fetch(:announcements)

    File.open('board_config.yaml', 'w') {|f| f.write @board_config.to_yaml }
  end
end