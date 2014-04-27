require 'clipboard'

class PrivateKeys < Array
  KEY_END = "\n-----END RSA PRIVATE KEY-----"

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
      key_end_index = key.index(KEY_END)
      if key_end_index
        last_characters = key[key_end_index - minimum_match_length...key_end_index]
        target.index(last_characters)
      end
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
