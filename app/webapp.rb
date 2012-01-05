require 'rubygems'
require 'sinatra'
require 'pp'
require 'common'

get '/' do
        data = []
        rejected = []
        output = "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"60\">"
        sort_by = params[:sort_by] || 'la1'
        ofile = File.expand_path(Common::config[:outputfile])
        file = open(ofile).read.split("\n")
        output +="<table border=1><tr><th><a href=\"?sort_by=srvname\">Server Name</a></th><th><a href=\"?sort_by=uptime\">Uptime</a></th><th><a href=\"?sort_by=usrlogin\">Logged In User</a></th><th><a href=\"?sort_by=la1\">LA1</a></th><th><a href=\"?sort_by=la2\">LA2</a></th><th><a href=\"?sort_by=la3\">LA3</a></th></tr>"
        file.each do |line|
          m = /(\w+)\s\d+\S\d+\S\d+\s\w+\s(\d+\s\w+).*(\d+\s\w+)\S\s+\w+\w+\s\w+\S\s(\d+\S\d+)\S\s(\d+\S\d+)\S\s(\d+\S\d+)/i.match(line.strip)
          m = /(\w+).*\s(\d+\S\d+).*(\d+\s\w+)\S\s+\w+\w+\s\w+\S\s(\d+\S\d+)\S\s(\d+\S\d+)\S\s(\d+\S\d+)\S/i.match(line.strip) if m.nil?
          unless m.nil?
              data << m
          else 
              rejected << line
          end
        end
        
        data = case sort_by
          when 'srvname'  
            data.sort{|a, b| a[1] <=> b[1]}
          when 'uptime'
            data.sort{|a, b| a[2].to_i <=> b[2].to_i}
          when 'usrlogin'
            data.sort{|a, b| b[3] <=> a[3]}
          when 'la1'
            data.sort{|a, b| b[4] <=> a[4]}
          when 'la2'
            data.sort{|a, b| b[5] <=> a[5]}
          when 'la3'
            data.sort{|a, b| b[6] <=> a[6]}
        end
        
        data.each do |m|
          bgclr = "#FF0000"
          bgclr = "#00FF00" if (m[4].to_i < 3)
          bgclr = "#00FF00" if (m[5].to_i < 3)
          bgclr = "#00FF00" if (m[6].to_i < 3)
          output+="<tr><td><b>#{m[1]}</b></td><td>#{m[2]}</td><td>#{m[3]}</td><td bgcolor=\"#{bgclr}\">#{m[4]}</td><td bgcolor=\"#{bgclr}\">#{m[5]}</td><td bgcolor=\"#{bgclr}\">#{m[6]}</td></tr>"
        end

        output+="</table>"

	if 0 < rejected.size
		r = "<table><tr><th>Couldn't Parse these lines</th></tr>"
		rejected.each do |l|
			r += "<tr><td>#{l}</td></tr>"
		end
		r += "</table>"
		output += r
	end
	output
end
