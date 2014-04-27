This will look for your private key in `~/.ssh/id_rsa`.

It will check your clipboard once per second, and if it detects that your clipboard is too similar to your private key, it will *replace the contents* of your clipboard.

Run with:
`ruby lib/main.rb`