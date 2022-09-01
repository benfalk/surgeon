# Surgeon

> A simple debug and diagnostic aid

## How to Install

In your Gemfile:

```ruby
gem 'surgeon', git: 'https://github.com/benfalk/surgeon.git'
```

## How to Use

```ruby
# Clears all measurements that have been made
Surgeon.prepare_for_surgery!

# Track counts to code paths
Surgeon.track(:some_code_area)
Surgeon.track(:some_code_area)

# Count and measure time
result = Surgeon.track(:some_math) { 14 * 3 }
result == 42

puts Surgeon.report
# Surgeon's Report:
#       some_math: (0001) (0.000002)
#  some_code_area: (0002)
```
