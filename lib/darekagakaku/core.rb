module Darekagakaku
def self.get
    _get SERVER
  end

  def self.post data
    @uri = URI.parse SERVER

    if File.exists?(File.expand_path(data))
      begin
        open(File.expand_path(data),"r") do |f|
          _post f.read
        end
      rescue Exception => e
        puts "error: #{e.message}"
      end
    else
      _post data
    end
  end

  def self.read t
    require 'date'
    fmt = "%Y-%m-%d"
    d = Time.now.strftime(fmt)

    if Time === t or Date === t or DateTime === t
      d = t.strftime(fmt)
    elsif String === t
      d = t
    end

    url = "#{SERVER}#{VIEW_ADDR}/#{d}"
    _get url
  end

  def self.help
    @help = [
      "usage: dareka [commands] [args]"
    ]

    cmds = (self.singleton_methods-self.private_methods).join(", ")
    @help << "commands: "+cmds

    puts @help.join("\n")
  end

  private

  def _get url
    begin
      ret = []
      open(url) do |res|
        body = res.read
        doc = Nokogiri::HTML(body)
        doc.xpath("//div[@class='content']").each do |el|
          ret << "-- "+el.xpath("h1")[0].text+" --"
          ret << el.xpath("p").map{|x| x.text}
        end
      end
      puts ret.flatten.join("\n")
    rescue Exception => e
      puts "error: #{e.message}"
    end
  end

  def _post txt
    begin
      Net::HTTP.start(@uri.host, @uri.port) do |http|
        req = Net::HTTP::Post.new POST_ADDR
        req.set_form_data({:text => txt})
        res = http.request req
      end

      puts "message: POST done!\n\n"
      get

    rescue Exception => e
      puts "error: #{e.message}"
    end
  end
end
