require 'net/https'
require 'nokogiri'

ONE_MOTORING_SITE = 'https://www.onemotoring.com.sg/content/onemotoring/en/on_the_roads/traffic_cameras0/woodlands.html'

FOLDER_HASH = {
    '2702' => 'WOODLANDS_TO_JB',
    '2701' => 'WOODLANDS_TO_SG',
    '4703' => 'TUAS_TO_SG',
    '4713' => 'TUAS_TO_JB'
}

uri = URI(ONE_MOTORING_SITE)
res = Net::HTTP.get_response(uri)

valid_images = Nokogiri::HTML(res.body).css("img").select{ |image| image.attr('src').match(/www.mytransport.sg/) }
image_src = valid_images.to_a.map { |image| 'https:' + image.attr('src') }

image_src.each do |image|
  filename = File.basename(image)
  folder_key = filename.split('_')
  folder = "images/#{FOLDER_HASH[folder_key[0]]}"

  unless Dir.exist? folder
    Dir.mkdir(folder)
  end

  open("#{folder}/#{filename}", 'wb') do |file|
    image_url = URI(image)
    image_response = Net::HTTP.get_response(image_url)
    file << image_response.body
  end
end
