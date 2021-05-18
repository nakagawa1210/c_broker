require "csv"

def main
  file = ARGV.size > 0 ?  ARGV[0] : exit

  data_list = CSV.read(file)
  data_list.shift
  
  n= 0
  
  data_list.each do |d|
    if d[1].to_f.between?(0.033, 0.044)
      n += 1
    end
  end
  
  filename = 'log/win_time.diff'
  CSV.open(filename,'a') do |test|
      test << [n,n*0.038,file]
  end
end

main
