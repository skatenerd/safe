require 'main'

describe PrivateKeys do
  it "knows when your clipboard is similar to one of the private keys" do
    PrivateKeys::Filesystem.stub(:all).and_return([
      "foo",
      "bar",
      "stuffstuffstuffstuffstuffabcdefghjiklmnopqrstuvwxyz\n-----END RSA PRIVATE KEY-----",
      "baz"
    ])
    keys = PrivateKeys.new(26)
    expect(keys.similar?('abcdefghjiklmnopqrstuvwxyz')).to be_true
    expect(keys.similar?('wat')).to be_false
  end
end

describe Main do
  it "replaces the clipboard if it is too close to the public key" do
    clipboard_contents = "badger badger badger badger mushroom mushroom"
    Clipboard.copy(clipboard_contents)
    PrivateKeys::Filesystem.stub(:all).and_return([clipboard_contents + PrivateKeys::KEY_END])
    Main.check_clipboard
    expect(Clipboard.paste).to eq(Main::CORRECTION_TEXT)
  end

  it "does not replace when different" do
    clipboard_contents = "badger badger badger badger mushroom mushroom"
    Clipboard.copy(clipboard_contents)
    PrivateKeys::Filesystem.stub(:all).and_return([])
    Main.check_clipboard
    expect(Clipboard.paste).to eq(clipboard_contents)
  end
end
