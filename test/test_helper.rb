$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sigfil'

require 'minitest/autorun'

def load_data_1d filename
  ary = []

  File.open(filename) do |fr|
    i = 0
    while line = fr.gets
      ary << ([i.to_f] + line.chomp.split.map {|x| x.to_f})
      i += 1
    end
  end

  return NMatrix[*ary]
end

def load_data filename
  ary = load_data_to_a(filename)

  return NMatrix[*ary]
end

def load_data_to_a filename
  ary = []
  File.open(filename) do |fr|
    while line = fr.gets
      ary << line.chomp.split.map {|x| x.to_f}
    end
  end

  return ary
end
