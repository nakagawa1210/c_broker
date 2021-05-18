require "csv"

def main
  @start = 0
  @end = 0
  file = ARGV.size > 0 ?  ARGV[0] : exit
  data =[]
  data_list = CSV.read(file)
  filename = file + '.csv'
  CSV.open(filename,'w') do |test|
    test << data_list.shift
    data_list.each.with_index(1) do |data,i|
      test << [i,
               data[2].to_f - data[1].to_f,
               data[3].to_f - data[2].to_f,
               data[4].to_f - data[3].to_f,
               data[4].to_f - data[1].to_f]
      if i == 1 then
        @start = data[1].to_f
      elsif i == data_list.length then
        @end = data[4].to_f
      end
    end
  end

  winpartfile = file.partition("win")
  _partfile = winpartfile[2].partition("_")
  winsize = _partfile[0].to_i
  
  mufile = file + ''
  mufile.insert(-4,"mu")
  
  CSV.open(mufile,'a') do |test|
    test << [winsize,ARGV[1],@end - @start]
  end
end

main
