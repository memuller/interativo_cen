class HomeController < ApplicationController
	caches_page :index, :search
	before_filter :redirect_empty_search, :only => [:search]
	
	def index
		@content = Home.fetch_and_parse_feed
	end

	def search
		@content = Home.search params[:q]
		render "index"
	end

	private
		def redirect_empty_search
			redirect_to :root unless params.has_key? :q
		end
end
