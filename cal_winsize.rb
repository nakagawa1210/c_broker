require "csv"

def main
  @start = 0
  @end = 0

  time = ARGV[0].to_s

  mulog_list = CSV.read('log/latest_file.mulog')

  datalist = Array.new(mulog_list.length){Array.new(4,0)}

  win_list = []

  mulog_list.each do |file|
    filename = 'log/' + file[0]
    record = CSV.read(filename)

    winsize = record[0][0].to_i
    
    unless win_list.include?(winsize) then
      win_list.push winsize
    end

    num = win_list.index(winsize)
    
    if record[0][1].to_i == 1 then
      datalist[num][1] = record[0][2].to_f
    elsif record[0][1].to_i == 2 then
      datalist[num][2] = record[0][2].to_f
    else
      datalist[num][3] = record[0][2].to_f
    end

    datalist[num][0] = winsize
  end
  
  putfilename = 'log/win_time_' + time + '.log'
  CSV.open(putfilename,'w') do |test|
    datalist.each do |data|
      next if data[0] == 0
      test << [data[0],data[1].to_f,data[2].to_f,data[3].to_f]
    end
  end
  putfilename = 'log/win_tps_' + time + '.log'
  CSV.open(putfilename,'w') do |test|
    datalist.each do |data|
      next if data[0] == 0
      test << [data[0],
               100000 / data[1].to_f,
               100000 / data[2].to_f,
               100000 / data[3].to_f]
    end
  end
  putfilename = 'log/win_gbps_' + time + '.log'
  CSV.open(putfilename,'w') do |test|
    datalist.each do |data|
      next if data[0] == 0
      test << [data[0],
               (8*1024) / (data[1].to_f * 10000),
               (8*2048) / (data[2].to_f * 10000),
               (8*4096) / (data[3].to_f * 10000)]
    end
  end
end

main
