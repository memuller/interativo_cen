module HomeHelper
	
	def get_id_podcast url
		url.gsub(/.+id=/,nil.to_s).gsub(/&.+/,nil.to_s)	
	end
	
	def get_image html
		html_scrap = Nokogiri::HTML::fragment(html) 
		img = html_scrap.css("img").first
		img.remove_attribute 'height'
		img.remove_attribute 'width'
		img.to_html
	end

	def getImageVideo entry
		if entry.url.include? "youtube"
			getImageYoutube entry.url
		else
			getImageWebtvcn entry.summary
		end
	end

	def getImageYoutube url
		image_tag "http://i2.ytimg.com/vi/#{ idYoutube url }/0.jpg", :width => 200 , :height => 154
	end

	def idYoutube url
		url.gsub(/.+v=/,nil.to_s).gsub(/&.+/,nil.to_s)
	end
	
	def getImageWebtvcn content
		get_image content
	end
	
	
end
