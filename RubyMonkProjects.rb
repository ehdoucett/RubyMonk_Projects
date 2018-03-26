# You should be able to paste these code bits into the RubyMonk Primer problems for the given name and have the results pass

# Build a Calculator

class Calculator
  def add(a, b)
   # your code here
    a+b
  end

  def subtract(a, b)
   # your code here
   a-b
  end
end


# Find the Frequency of a String

def find_frequency(sentence, word)
  # Your code here
  a=sentence.downcase.split
  a.count(word)
end


# Sort the words in a given sentence

def sort_string(string)
  # your code here
  a = string.split(" ")
  b = a.sort{|x,y| x.length <=> y.length}
  b[0]<<' '<<b[1]<<' '<<b[2]
end


# Select random elements from an array

def random_select(array, n)
  # your code here
  len = array.size
  result = []
  n.times do 
    result = result << array[rand(len)]    
  end
  return result
end


# Find the length of strings in an array

def length_finder(input_array)
  out_arr = []
  input_array.each do |i|
    out_arr = out_arr << i.length
  end
  return out_arr
end


# Hiring Programmers - Boolean Expressions in Ruby

is_an_experienced_programmer = (
  (candidate.years_of_experience >= 2 || candidate.github_points >= 500) && candidate.languages_worked_with.include?("Ruby") && candidate.age >= 15 && !candidate.applied_recently?
  )
  
  
# Palindromes  

def palindrome?(sentence)
  # Write your code here
  sentence = sentence.downcase.gsub(' ','')
  reverse = ''
  i = 1
  sentence.length.times do
    reverse = reverse << sentence[-i]
    i = i.next
  end
  return reverse == sentence
end


# Compute sum of cubes for given range

def sum_of_cubes(a, b)
  # Write your code here
  i = a
  result = i**3
  loop do
    if i == b 
      break
    else
      i = i + 1
      result = result + i**3
    end
  end
    return result
end
 
 
# Find non-duplicate values in an Array

def non_duplicated_values(values)
  # Write your code here
  out_arr = values
  values.each do |x|
    n = values.select {|y| y == x}
    if n.length > 1
      out_arr.delete_if {|y| y == x}
    end
  end
  return out_arr
end


# Check if all elements in an array are Fixnum

def array_of_fixnums?(array)
  # Write your code here
  n = 0
  n = array.select {|x| x.is_a?(String) }
  if n.length == 0
    return true
  else 
    return false
  end 
end


# Kaprekar's Number

def kaprekar?(k)
  k2 = k**2
  n = "#{k}".length
  num_digits_k2 = "#{k2}".length
  right_n = k2 % (10**n)
  left = k2 / (10**n)
  k == (right_n + left)
end


# Number shuffle

def number_shuffle(number)
  # your code here
  len = "#{number}".length
  arr = []
  i = 0
  num = 1
  len.times do 
    x = number % 10**(i+1)
    arr[i] = x / (10**i)
    i = i + 1
    num = num * i
  end
  result = []
  loop do 
    if result.length == num
      break
    else
      x = arr.shuffle
      y = 0
      i = 10**(arr.length-1)
      x.each do |k|
        y = y + (k * i)
        i = i / 10
      end
      result.push(y)
      result = result.uniq
    end
  end
    return result.sort
end


# Time to run code

def exec_time(proc)
  # your code here
  h = Time.now
  puts proc.call
  n = Time.now
    return n - h  
end	


# Your sum

class MyArray
  attr_reader :array

  def initialize(array)
    @array = array
  end

  def sum(initial_value = 0)
    if block_given?
      res = initial_value
      array.each do |i|
        res = res + yield(i)
      end
      return res
    else
      res = initial_value
      array.each do |i|
        res = res + i
      end
      return res
    end
  end
end


# Orders and costs

class Restaurant
  def initialize(menu)
    @menu = menu
  end

  def cost(*orders)
    # your code here
    total = 0
    orders.each do |ord|
      ord.each do |i, q|
        p = @menu[i]
        c = p * q
        total = total + c
      end
    end
    return total
  end
end


# Enough Contrast?

class Color
  attr_reader :r, :g, :b
  def initialize(r, g, b)
    @r = r
    @g = g
    @b = b
  end

  def brightness_index
    # your code here
    return ( 299 * r + 587 * g + 114 * b) / 1000
  end

  def brightness_difference(another_color)
    #your code here
    return (brightness_index - another_color.brightness_index).abs
  end

  def hue_difference(another_color)
    #your code here
    return ((r - another_color::r).abs + (g - another_color::g).abs + (b - another_color::b).abs)
  end

  def enough_contrast?(another_color)
    # your code here
    if brightness_difference(another_color) > 125 && hue_difference(another_color) > 500 
      true
    else
      false
    end
  end
end


