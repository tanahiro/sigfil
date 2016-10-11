
include Math

N = 100

def one_d_1
  signal = []
  N.times do |i|
    signal << (sin(i/N.to_f*2*PI) + rand/10)
  end

  signal[10]  = -1.8
  signal[70]  = 1.8
  signal[N/2] = 0.9

  File.open("1d-1.dat", "w") {|fw| fw.puts(signal.join("\n"))}
end

def two_d_circle
  signal = []

  N.times do |i|
    theta = i/N.to_f*2*PI

    signal << [cos(theta) + rand/10.0, sin(theta) + rand/10.0]
  end

  signal[10] = [0.2, 0.2]
  signal[30] = [1.2, 0.7]
  signal[70] = [-0.2, -1.2]

  File.open("2d-circle.dat", "w") do |fw|
    signal.each {|s| fw.puts(s.join(" "))}
  end
end

def three_d_random
  signal = []
  
  m = 10

  N.times do |i|
    signal << [10*rand, 10*rand, 10*rand]
  end

  signal[10] = [20, 20, 10]
  signal[30] = [-20, -20, 10]
  signal[70] = [20, -20, 0]

  File.open("3d-random.dat", "w") do |fw|
    signal.each {|s| fw.puts(s.join(" "))}
  end
end

