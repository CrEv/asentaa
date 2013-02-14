# Asentaa

Mac installer, written in ruby.

Install app from `dmg`, both `app` and `pkg`.


## Usage

```ruby
require 'macinstall.rb'

myapp = MacInstall.new "/a/path/to/a/dmg/file"
myapp.install
```

That's all foks!
