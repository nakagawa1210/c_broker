require "csv"

def main
  t = Time.new
  time = t.strftime("%Y%m%d_%H%M")
  
  log_list = CSV.read('log/latest_file.latelog')

  filename = ['',
              'log/win_ave_' + time + '_1.log',
              'log/win_ave_' + time + '_2.log',
              '',
              'log/win_ave_' + time + '_4.log']
  
  log_list.each do |file|
    time_stamp = CSV.read("log/" + file[0])
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
    
    buf = file[0].partition("win")
    buf2 = buf[2].split("_")

    winsize = buf2[0].to_i
    paketsize = buf2[2].to_i

    CSV.open(filename[paketsize],'a') do |test|
      test << [winsize,snd_sum/100000,svr_sum/100000,rcv_sum/100000,all_sum/100000]
    end
  end
end

main
