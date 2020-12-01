i=$<.map(&:to_i)
puts [2,3].map{|n|i.combination(n).find{|x|x.sum==2020}.reduce:*}