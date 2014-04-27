require 'clipboard'

class LongestCommonSubstring
  @@last_input = []
  @@last_answer = 0

  def self.length_for_pair(a,b)
    if @@last_input == [a,b]
      return @@last_answer
    else
      @@last_input = [a,b]
      @@last_answer = compute_length_for_pair(a,b)
      @@last_answer
    end
  end

  #taken from wikipedia
  def self.compute_length_for_pair(a,b)
    prefix_length_cache = (0..a.length).map { [] }
    longest = 0
    (0...a.length).each do |i|
      (0...b.length).each do |j|
        if a[i] == b[j]
          if i == 0 || j == 0
            prefix_length_cache[i][j] = 1
          else
            prefix_length_cache[i][j] = prefix_length_cache[i-1][j-1] + 1
          end
          if prefix_length_cache[i][j] > longest
            longest = prefix_length_cache[i][j]
          end
        else
          prefix_length_cache[i][j] = 0
        end
      end
    end
    return longest
  end
end

class PrivateKeys < Array
  class Filesystem
    def self.all
      [`cat ~/.ssh/id_rsa`]
    end
  end

  attr_accessor :minimum_match_length

  def initialize(minimum_match_length)
    super(Filesystem.all)
    self.minimum_match_length = minimum_match_length
  end

  def similar?(target)
    any? do |key|
      lcs_length = LongestCommonSubstring.length_for_pair(key, target)
      lcs_length >= self.minimum_match_length
    end
  end
end

class Main
  MINIMUM_MATCH_LENGTH = 30;
  CORRECTION_TEXT = "https://en.wikipedia.org/wiki/Public-key_cryptography"
  SLEEP_TIME = 1

  def self.check_clipboard
    keys = PrivateKeys.new(MINIMUM_MATCH_LENGTH)
    if keys.similar?(Clipboard.paste)
      Clipboard.copy(CORRECTION_TEXT)
    end
  end

  def self.run
    while true
      check_clipboard
      sleep(SLEEP_TIME)
    end
  end
end

if __FILE__ == $0
  Process.daemon
  Main.run
end
