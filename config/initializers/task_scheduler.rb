require 'rake'
require 'rufus/scheduler'
load File.join( RAILS_ROOT, 'Rakefile')

scheduler = Rufus::Scheduler.start_new

scheduler.every '1m', :blocking => true  do
	Dir[File.join("#{RAILS_ROOT}/public/cache/**","*.{html,rss,mrss,xhtml}")].each do |entry|
		if Time.now > File::mtime(entry) + 300 
			File.delete(entry) if File::exists?(entry)
		end
	end
end