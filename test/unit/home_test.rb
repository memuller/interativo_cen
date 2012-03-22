require 'test_helper'

class HomeTest < ActiveSupport::TestCase


	test "should get all rss" do
		content = Home.get_rss()
		assert_kind_of Hash, content
	end

	test "has 5 hash" do
		content = Home.get_rss()
		assert_equal 5,content.size
	end

	test "should get photo feed" do
		content = Home.get_rss()
		assert_not_nil content.entries[0]
	end

	test "should have entries" do
		content = Home.get_rss()
		assert_not_nil content.entries[0].entries.size		
	end
end