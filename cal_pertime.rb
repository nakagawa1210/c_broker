require "csv"

def main
  file = ARGV.size > 0 ?  ARGV[0] : exit

  time_stamp = CSV.read(file)
  rm = time_stamp.shift

  snd_sum = 0.0
  svr_sum = 0.0
  rcv_sum = 0.0
  all_sum = 0.0
  
  time_stamp.each do |data|
    snd_sum += data[1].to_f
    svr_sum += data[2].to_f
    rcv_sum += data[3].to_f
    all_sum += data[4].to_f
  end

  puts "#{snd_sum},#{svr_sum},#{rcv_sum},#{all_sum}"
  puts "#{snd_sum/100000},#{svr_sum/100000},#{rcv_sum/100000},#{all_sum/100000}"
  puts "#{(snd_sum/all_sum)*100}%,#{(svr_sum/all_sum)*100}%,#{(rcv_sum/all_sum)*100}%"
  
end

main
