require 'time'
require 'active_support/core_ext/numeric/time'

def format(time, statement)
  minutes = pad(time / 60)
  seconds = pad(time % 60)
  "#{statement} #{minutes}:#{seconds}\r"
end

def pad(time)
  time < 10 ? "0#{time}" : time.to_s
end

def speak(statement)
  `spd-say '#{statement}'`
end

def countdown_timer(time, statement)
  loop do
    break if time == 0
    Thread.new do
      print format(time, statement)
    end
    time -= 1
    sleep(1)
  end
end

def adjust_statement(statement)
  statement == $start_statement ? $end_statement : $start_statement
end

def cycle(statement, time)
  statement = adjust_statement(statement)
  speak(statement)
  countdown_timer(time, statement)
  statement
end

$start_statement = 'End break. Begin work.'
$end_statement = 'End work. Begin break.'
statement = $end_statement

loop do
  statement = cycle(statement, 25.minutes)
  statement = cycle(statement, 5.minutes)
end
