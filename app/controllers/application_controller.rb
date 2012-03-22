# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

	private
	
		def render_public file_name
	    render :file => "#{RAILS_ROOT}/public/#{file_name}.html", :content_type => 'text/html', :layout => true		
		end
 
end
