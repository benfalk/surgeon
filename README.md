# Surgeon

> A simple debug and diagnostic aid

## How to Install

In your Gemfile:

```ruby
gem 'surgeon', git: 'https://github.com/benfalk/surgeon.git'
```

## How to Use

```ruby
# Clears all data that has been recorded and prepares for a new surgery
Surgeon.prepare_for_surgery!

# Track counts to code paths
Surgeon.track(:some_code_area)
Surgeon.track(:some_code_area)

# Count and measure time
result = Surgeon.track(:some_math) { 14 * 3 }
result == 42

while result > 13
  # run this debug only one time; handy when you want to
  # check into something once time w/o constantly stopping
  # on it every iteration
  Surgeon.run_once(:inspect_result_loop) { binding.pry }
  result -= 1
end

puts Surgeon.report
# Surgeon's Report:
#       some_math: (0001) (0.000002)
#  some_code_area: (0002)
```

## Additional Tracking Helpers

### Track Whole Methods

Instead of wrapping a whole method body with a `track` block
you can instead use `Surgeon.track_method!` and `Surgeon.track_init!`

```ruby
class Greeter
  def hello(name)
    "hello #{name}"
  end
end

# Ergonomic for Surgeon.track_method!(Greeter, :initialize)
Surgeon.track_init!(Greeter)
Surgeon.track_method!(Greeter, :hello)
Surgeon.prepare_for_surgery!

greater = Greeter.new
greater.hello('Mark') == 'hello Mark'
greater.hello('Sarah') == 'hello Sarah'

puts Surgeon.report
# Surgeon's Report:
#        Greeter#hello: (0002) (0.000007)
#   Greeter#initialize: (0001) (0.000002)
```
