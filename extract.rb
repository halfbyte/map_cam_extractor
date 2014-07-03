require 'rubygems'
require 'bundler/setup'
require 'date'
require 'csv'
# require 'riffy'

filename = ARGV[0]
exit 3 unless File.exist?(filename)
s = ""
counter = 0

def word_to_bytes(a) 
  [a & 0xFF, (a >> 8) & 0xFF, (a >> 16) & 0xFF, (a >> 32) & 0xFF]
end

def bytes_to_word(*a)
  a.map(&:chr).join.unpack("i!<")[0]
end


CHUNK_SIZE = 1000
CSV.open(ARGV[1], 'wb') do |csv|
  csv << ["latitude", "longitude", "time", "battery", "altitude", "distance", "speed", "frame_number"]
File.open(ARGV[0], 'rb') do |f|
  last = nil
  loop do
    s = s[-CHUNK_SIZE,CHUNK_SIZE] || ""
    loop do
      s << f.read(CHUNK_SIZE)
      counter += 1
      # puts counter * CHUNK_SIZE
      #puts s.length
      r = s.match(/GPS (.{58}?)(01wb|00dc)/mn)
      if r
        bytes = r[1].bytes
        #puts r.inspect
        
        date_range = bytes[12,4]
        # date = Date.new((date_range[1] << 8) + date_range[0], date_range[2], date_range[3])
        # puts date.to_s
        
        time_range = bytes[16,4]
        
        milliseconds = (time_range[3] << 8) + time_range[2]
        
        time = Time.new((date_range[1] << 8) + date_range[0], date_range[2], date_range[3], time_range[0], time_range[1], milliseconds / 1000, "+00:00")
        
      
        #puts "TIME: #{time.to_s}"
      
        gps_range = bytes[20,8]
        # csv << bytes
        
      
        
        lat = bytes_to_word(*gps_range[0,4]).to_f / 1000_000.0
        lon = bytes_to_word(*gps_range[4,4]).to_f / 1000_000.0
        
        elevation = bytes_to_word(*bytes[28,4]).to_f / 10.0
        distance = bytes_to_word(*bytes[40,4]).to_f / 10_000.0
        
        speed = bytes_to_word(*bytes[32,4]).to_f / 1_000_000.0 * 1.609344 # miles in km

        frame_number = bytes_to_word(*bytes[0,4])
        unknown2 = bytes_to_word(*bytes[4,4])
        unknown3 = bytes_to_word(*bytes[8,4])
        unknown4 = bytes_to_word(*bytes[12,4])
        
        
        unknown6 = bytes_to_word(*bytes[36,4])
        
        
        battery = bytes_to_word(*bytes[44,4]).to_f / 1000.0
        
        line = [lat, lon, time, battery, elevation, distance, speed, frame_number, unknown2, unknown3, unknown4, unknown6] + bytes[48,10]
        
        # deduplication
        if line != last        
          csv << line
        end
        last = line
        
        # csv << bytes
        # puts [lat, lon].inspect
        time = 0
        i = 0
        bytes[0,8].each do |byte|
          time += byte << (i*8)
          i+=1
        end
        # puts time
        break
      end
      break if f.eof?
    end
    break if f.eof?
  end
end
end
puts "done"
#
#
#
# 1c020000   28 02 0 0
# 32000000   50 0 0 0
# 0100f401   1 0 244 1
# de070701
# 13311027000000000000000000000000000000000f1a000300000000d3090000a46e9a00012a78000102