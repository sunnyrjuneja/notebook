# --- Day 5: Doesn't He Have Intern-Elves For This? ---
# 
# Santa needs help figuring out which strings in his text file are naughty or nice.
# 
# A nice string is one with all of the following properties:
# 
# It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
# For example:
# 
# ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
# aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
# jchzalrnumimnmhp is naughty because it has no double letter.
# haegwjzuvuyypxyu is naughty because it contains the string xy.
# dvszwmarrgswjxmb is naughty because it contains only one vowel.
# How many strings are nice?
require 'maxitest/autorun'

class VowelState
  attr_accessor :vowels_seen

  VOWELS = ['a', 'e', 'i', 'o', 'u']

  def initialize
    @vowels_seen = []
  end

  def check(letter)
    vowels_seen.push(letter) if !satsified? && vowels.include?(letter)
  end

  def satsified?
    vowels_seen.length > 2
  end

  def vowels
    VOWELS
  end
end

describe VowelState do
  before { @s = VowelState.new }

  context 'satsified' do
    it 'satsified by 3 vowels in the begining' do
      'aeiz'.split('').each { |c| @s.check c }
      assert @s.satsified?
    end

    it 'satsified by 3 vowels in the end' do
      'zaei'.split('').each { |c| @s.check c }
      assert @s.satsified?
    end
  end

  context 'not satsified' do
    it 'less than 3 vowels' do
      'ae'.split('').each { |c| @s.check c }
      refute @s.satsified?
    end

    it 'no vowels' do
      'zzz'.split('').each { |c| @s.check c }
      refute @s.satsified?
    end
  end
end

class ConsecutiveState
  attr_accessor :current, :previous

  def initialize
    @current = nil
    @previous = nil
  end

  def check(letter)
    unless satsified?
      self.previous = current
      self.current = letter
    end
  end

  def satsified?
    current == previous && !current.nil?
  end
end

describe ConsecutiveState do
  before { @s = ConsecutiveState.new }

  context 'satsified' do
    it 'satsified by 2 consecutive in the begining' do
      'aaz'.split('').each { |c| @s.check c }
      assert @s.satsified?
    end

    it 'satsified by 2 consecutive in the end' do
      'zaa'.split('').each { |c| @s.check c }
      assert @s.satsified?
    end
  end

  context 'not satsified' do
    it 'no consecutive' do
      'zaza'.split('').each { |c| @s.check c }
      refute @s.satsified?
    end
  end
end

class BlackListState 
  BLACK_LIST = ['ab', 'cd', 'pq', 'xy']
  attr_accessor :current, :previous

  def initialize
    @current = nil
    @previous = nil
    @black_listed = false
  end

  def check(letter)
    if satsified?
      self.previous = current
      self.current = letter
    end
  end

  def satsified?
    !black_listed?
  end

  def black_listed?
    if current.nil? || previous.nil?
      false
    else
      black_list.include?(previous + current)
    end
  end

  def black_list
    BLACK_LIST
  end
end

describe BlackListState do
  before { @s = BlackListState.new }

  context 'satsified' do
    it 'without items in the blacklist' do
      'aa'.split('').each { |c| @s.check c }
      assert @s.satsified?
    end
  end

  context 'not satsified' do
    it 'items in the blacklist in the begining' do
      'abaa'.split('').each { |c| @s.check c }
      refute @s.satsified?
    end

    it 'items in the blacklist in the end' do
      'aaab'.split('').each { |c| @s.check c }
      refute @s.satsified?
    end
  end
end

class NiceString
  attr_reader :string, :states, :nice

  def initialize(s)
    @string = s
    @states = [
      VowelState.new,
      ConsecutiveState.new, 
      BlackListState.new
    ]
    @nice = nil
  end

  def nice?
    if @nice.nil?
      string.split("").each do |c|
        states.each { |s| s.check(c) }
      end

      @nice = !states.map(&:satsified?).include?(false)
    end
    @nice
  end
end

f = File.new('day_05.input')
counter = 0

f.each do |l|
  counter += 1 if NiceString.new(l.chomp).nice?
end

puts counter
