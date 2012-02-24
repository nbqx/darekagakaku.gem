%w(open-uri net/http nokogiri).each{|x| require x}
%w(version core).each{|x| require  File.expand_path("lib/darekagakaku/#{x}")}

module Darekagakaku
  SERVER = "http://darekagakaku.herokuapp.com"
  HOME_ADDR = "/"
  POST_ADDR = "/w"
  VIEW_ADDR = "/v"

  extend Darekagakaku
end
