require "csv"

def main
  @start = 0
  @end = 0
  file = ARGV.size > 0 ?  ARGV[0] : exit

  datalist = Array.new(100000){Array.new(4,0)}

  time_stamp = CSV.read(file)
  
  filename = file + '.csv'
  time_elapsed = CSV.read(filename)

  putfilename = file + ''
  putfilename.insert(-4,"time")

  trash = time_stamp.shift
  trash = time_elapsed.shift
  
  time_stamp.each.with_index(0) do |data,i|
    datalist[i][0] = data[1]
    datalist[i][1] = data[3]
  end

  time_elapsed.each.with_index(0) do |data,i|
    datalist[i][2] = data[1]
    datalist[i][3] = data[3]
  end
  
  CSV.open(putfilename,'w') do |test|
    datalist.each do |data|
      test << [data[0].to_f,data[1].to_f,data[2].to_f,data[3].to_f]
    end
  end
  
end

main
