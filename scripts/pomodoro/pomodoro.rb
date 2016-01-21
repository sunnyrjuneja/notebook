require 'active_support/core_ext/numeric/time'

loop do
  `spd-say "begin working"`
  sleep(25.minutes)
  `spd-say "take a break"`
  sleep(5.minutes)
end
