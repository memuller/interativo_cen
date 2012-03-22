class	Home
	
	DEFAULT_TAG = "cen2010"
	FEED_ADDRESS = [
				"http://cen.mashup.cancaonova.com/photo/#{DEFAULT_TAG}.rss",
				"http://cen.mashup.cancaonova.com/microblog/#{DEFAULT_TAG}.rss",
				"http://www.webtvcn.com/feed/grupos/nome/cen_2010", 			
				"http://cen.mashup.cancaonova.com/video/#{DEFAULT_TAG}.rss", 
				"http://prt01.cancaonova.com/podcast.cancaonova.com/rss/canal.xml.php?idCanal=180"
	]
	
	def self.fetch_and_parse_feed 
		@entries = Hash.new
		Feedzirra::Feed.fetch_and_parse(FEED_ADDRESS	,
			:on_failure => lambda {|feed_url, response_code, response_header, response_body| 
					notify_failure feed_url , [response_code, response_header, response_body]
					check_type_and_add_entrie feed_url, []
				} , 
			:on_success => lambda {|feed_url, feed_content|
				check_type_and_add_entrie feed_url, feed_content
			}
		)	
		@entries	
	end
	
	def self.search search_by
		delete_webtv_feed_address
		add_query_param_in_feed_address search_by			
		fetch_and_parse_feed
		empty_audio_entries!
		@entries	
	end
	
	private
		
		# Because search dont work in webtcn by FEED 
		def self.delete_webtv_feed_address
			FEED_ADDRESS.delete_at 2
		end

		def self.add_query_param_in_feed_address search
			FEED_ADDRESS.each do |item | item.gsub!( DEFAULT_TAG, DEFAULT_TAG + '+' + search) end
		end
		
		# Because search dont work in pocastCN by FEED 
		def self.empty_audio_entries!
			@entries['audio'] = []
		end

		def self.check_type_and_add_entrie feed, entries
			type = media_type? feed 
			add_entrie_by_type!(entries, type)
		end
		
		def self.add_entrie_by_type!(feedContent, type)
			if @entries.has_key? type
	 			@entries[type] += feedContent.entries
				@entries[type].sort! {|x,y| y.published <=> x.published }
			else
	 			@entries[type] = feedContent.entries
			end
		end
			
		def self.media_type? url
			case url.match(/[a-z]*\.[a-z]*.[a-z]{3}\/([a-z]*)\//)[1]
				when "microblog" then "microblog"
				when "photo" then "image"
				when "feed" then "video"
				when "video" then "video"
				when "rss" then "audio"
			end
		end
	
		def self.notify_failure url, *response
			HoptoadNotifier.notify(
			   :error_class => "Special Error fetch and parse",
			   :error_message => "Erro ao acessar = #{url}
													  response= #{response.inspect}",
			   :request => { :params => nil }
			)		
		end
end