require "csv"
def per (val, all_val)
   return val.to_f / all_val.to_f * 100
end
                                                          
def main
  @data_sum = [0.0,0.0,0.0,0.0]
  
  file = ARGV.size > 0 ?  ARGV[0] : exit                  
  data =[]                                                
  data_list = CSV.read(file) #read TIME.csv file
  sp_file = file.split(".")
  filename = sp_file[0] + '+%' + '.' + sp_file[2]
  CSV.open(filename,'w') do |test|
    data_list.shift
    data_list.each do |data|
      test << [data[0],data[1],data[2],data[3],data[4],
               per(data[1],data[4]), per(data[2],data[4]),
               per(data[3],data[4])]
      4.times do |i|
        @data_sum[i] += data[i+1].to_f
      end
    end
    test << [@data_sum[0],@data_sum[1],@data_sum[2],@data_sum[3],
             per(@data_sum[0],@data_sum[3]),per(@data_sum[1],@data_sum[3]),
             per(@data_sum[2],@data_sum[3])]
  end
  puts filename
end                                                       
                                                          
main                                                      
