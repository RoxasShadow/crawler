#!/usr/bin/env ruby
require 'net/http'

class Crawler
	def Crawler.get(url)
		Net::HTTP.start(url) { |http| http.get('/').body }
	end
	
	def Crawler.page_name(url)
		# http://www.ftw.com/lol/trololol.rb => /lol/trololol.rb
	end

	def Crawler.parse(page, what, opt=nil)
		case what
			when :cmt then page.scan(/\<!\s*--(.*?)(--\s*\>)/m)
			#when :url then page.scan(/href=[\'"]?([^\'" >]+)\.#{opt if opt.is_a? Symbol}/m)
			when :url
				if opt.is_a? Symbol
					page.scan(/href=[\'"]?([^\'" >]+)/m).delete_if { |elm|
						!elm.to_s.include? ".#{opt.to_s}"
					}
				else
					page.scan(/href=[\'"]?([^\'" >]+)/m)
				end
			else nil
		end
	end
end

class NilClass
	def join(sep=$,)
		'pff'
	end
end

page = Crawler.get('www.giovannicapuano.net')
comments = Crawler.parse(page, :cmt)
urls = Crawler.parse(page, :url)
css = Crawler.parse(page, :url, :css)
exc = Crawler.parse(page, :trolol)

puts 'Comments----------------------------------------', comments.join, "\n\n"
puts 'URLS----------------------------------------', urls.join("\n"), "\n\n"
puts 'CSS----------------------------------------', css.join("\n"), "\n\n"
puts 'Fail----------------------------------------', exc.join
