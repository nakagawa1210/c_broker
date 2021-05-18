require "csv"

def main
  file = ARGV.size > 0 ?  ARGV[0] : exit

  data_list = CSV.read(file)
  data_list.shift
  
  h_data = Array.new(11){Array.new(4,0)}

  rng = 0.002

  rng_ar = []
  12.times do |n|
    rng_ar.push rng*n
  end

  data_list.each do |d|
    4.times do |d_n|
      n=10
      10.times do |i|
        if d[d_n+1].to_f.between?(rng_ar[i], rng_ar[i+1])
          n = i
          break
        end
      end
      h_data[n][d_n] = h_data[n][d_n].to_i + 1 
    end
  end
  
  filename = file + '.latency'
  CSV.open(filename,'w') do |test|
    11.times do |n|
      test << [(rng_ar[n] + rng_ar[n+1]) / 2,
               h_data[n][0],
               h_data[n][1],
               h_data[n][2],
               h_data[n][3]]
    end 
  end
end

main
