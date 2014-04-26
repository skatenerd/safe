require 'clipboard'
require 'diff/lcs'

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
      lcs = Diff::LCS.LCS(key.split(""), target.split(""))
      lcs.count >= self.minimum_match_length
    end
  end
end

class Main
  MINIMUM_MATCH_LENGTH = 30;
  CORRECTION_TEXT = "https://en.wikipedia.org/wiki/Public-key_cryptography"

  def self.check_clipboard
    keys = PrivateKeys.new(MINIMUM_MATCH_LENGTH)
    if keys.similar?(Clipboard.paste)
      Clipboard.copy(CORRECTION_TEXT)
    end
  end

  def self.run
    while true
      check_clipboard
      sleep(0.5)
    end
  end
end

if __FILE__ == $0
  Process.daemon
  Main.run
end
