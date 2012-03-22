ActionController::Routing::Routes.draw do |map|

	map.about_us '/sobre_o_cen_2010' , :controller => :institutional , :action => :about_us
	map.contact_us '/fale_conosco' , :controller => :institutional , :action => :contact_us
	map.how_to_arrive '/como_chegar' , :controller => :institutional , :action => :how_to_arrive
	map.how_contribute '/como_contribuir' , :controller => :institutional , :action => :how_contribute

	map.search '/buscar/:q', :controller => :home , :action => :search , :q => nil

	map.root :controller => :home 
end
