module Rubydojo
  class Lesson
    attr_reader :id, :title, :level, :description, :explanation, :code_template, :validation_code, :hint

    def initialize(id:, title:, level:, description:, explanation:, code_template:, validation_code:, hint:)
      @id = id
      @title = title
      @level = level
      @description = description
      @explanation = explanation
      @code_template = code_template
      @validation_code = validation_code
      @hint = hint
    end

    def self.all
      @all ||= LOADED_LESSONS
    end

    def self.find(id)
      all.find { |l| l.id.to_s == id.to_s }
    end

    def self.next_lesson(current_id)
      current_index = all.index { |l| l.id.to_s == current_id.to_s }
      return nil unless current_index && current_index < all.size - 1
      all[current_index + 1]
    end

    LOADED_LESSONS = [
      new(
        id: "variables",
        title: "Variables & Constants",
        level: "Level 1: Ruby Essentials",
        description: "Understand the backbone of Ruby storage: local variables, constants, and basic methods.",
        explanation: <<~MARKDOWN,
          # Variables & Constants in Ruby

          In Ruby, variables are dynamically typed. This means you do not need to declare their data types (like `int` or `String`). Ruby determines the type at runtime.

          Here are **5 detailed points** you must master regarding variables, constants, and scope in Ruby:

          ### 1. Local Variables & Naming Conventions
          Local variables are the most common variable type. They are defined without a keyword (unlike `var` or `let` in JS) and must start with a lowercase letter or an underscore `_`.
          * **Naming Convention**: Ruby uses `snake_case` for local variables.
          * **Scope**: A local variable's scope is strictly bounded by the local context in which it is defined: a method body, block, class definition, or loop. It does *not* leak outside these scopes.
          ```ruby
          user_age = 25
          _temp_val = "cached"
          ```

          ### 2. Instance Variables (`@variables`)
          Instance variables represent the **state** of an object. They are prefixed with a single `@` sign.
          * **Scope**: They are accessible across all instance methods of a class instance.
          * **Defaults**: If you reference an uninitialized instance variable, Ruby returns `nil` instead of raising an error!
          * **Rails Context**: In Rails, controllers set instance variables (e.g. `@users = User.all`) which are then automatically shared with your view files (like `.html.erb`).
          ```ruby
          class User
            def set_name(name)
              @name = name # Accessible anywhere in this object instance
            end
          end
          ```

          ### 3. Class Variables (`@@variables`)
          Class variables are prefixed with two `@` signs.
          * **Scope**: They are shared across the class itself, all instances of the class, and all subclasses of the class.
          * **Warning**: Because they are shared across subclass hierarchies, a change in a subclass will modify the value in the parent class. In modern Ruby, they are generally avoided in favor of class instance variables (`@variable` defined directly inside the class definition).
          ```ruby
          class Application
            @@connection_count = 0 # Shared across all subclasses and instances
          end
          ```

          ### 4. Global Variables (`$variables`)
          Global variables are prefixed with a dollar sign `$`.
          * **Scope**: They are accessible from anywhere in the entire Ruby program, regardless of class or method boundaries.
          * **Best Practice**: Use them very sparingly. Global mutable state makes code hard to test and debug. The most common use cases are standard system variables provided by Ruby, like `$stdout` (current output stream) or `$PROGRAM_NAME`.
          ```ruby
          $system_mode = :production # Accessible globally
          ```

          ### 5. Constants & the Constant Warning System
          Constants start with a capital letter and are typically written in `ALL_UPPERCASE`.
          * **Reassignment**: Unlike other languages, Ruby does *not* prevent you from modifying constants. If you change a constant, Ruby will execute the assignment but emit a warning in the console: `warning: already initialized constant...`.
          * **Lookup**: Constants are lexically looked up through the nesting of classes and modules.
          ```ruby
          PI = 3.14159
          PI = 3.0 # Works, but warns "warning: already initialized constant PI"
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Define a local variable `age` and set it to `25`.
          2. Define a constant `PLANET` and set it to `"Earth"`.
          3. Define a method `greet(name)` that returns `"Hello, #{name}!"`. (Note: Ruby methods implicitly return the last evaluated expression!)
        MARKDOWN
        code_template: <<~RUBY,
          # 1. Define local variable age below
          age = 
          
          # 2. Define constant PLANET below
          PLANET = 
          
          # 3. Define method greet(name) below
          def greet(name)
            # Your code here
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Local variable 'age' must be defined" unless binding.local_variable_defined?(:age)
          user_age = binding.local_variable_get(:age)
          raise "Variable 'age' should be 25, got \#{user_age.inspect}" unless user_age == 25
          
          raise "Constant 'PLANET' must be defined" unless self.class.const_defined?(:PLANET) || binding.eval("defined?(PLANET)")
          planet_val = binding.eval("PLANET")
          raise "Constant 'PLANET' should be 'Earth', got \#{planet_val.inspect}" unless planet_val == "Earth"
          
          raise "Method 'greet' is not defined" unless respond_to?(:greet)
          greet_test = greet("Jayesh")
          raise "Method 'greet' should return 'Hello, Jayesh!', got \#{greet_test.inspect}" unless greet_test == "Hello, Jayesh!"
        RUBY
        hint: "Make sure you use double quotes for strings, and remember that methods in Ruby implicitly return the last statement."
      ),

      new(
        id: "arrays",
        title: "Collections & Arrays",
        level: "Level 2: Collections",
        description: "Master the structure of Ruby lists (Arrays) and how to query, append, and slice them.",
        explanation: <<~MARKDOWN,
          # Collections & Arrays in Ruby

          Arrays are ordered, integer-indexed collections of any object. In Ruby, arrays are highly dynamic and can hold heterogeneous elements.

          Here are **5 detailed points** explaining how arrays operate in Ruby:

          ### 1. Dynamic Resizing & Heterogeneous Contents
          Unlike compiled languages where arrays have fixed sizes and strictly typed contents (e.g. only integers), Ruby arrays grow and shrink dynamically. A single array can hold strings, floats, classes, and nested arrays simultaneously.
          ```ruby
          mixed = [1, "two", 3.0, [4, 5]] # Fully valid!
          ```

          ### 2. Indexing and Negative Offsets
          Array indexes start at `0`.
          * **Negative Offsets**: You can access elements from the end of the array using negative integers. `-1` is the last element, `-2` is the second-to-last, and so on.
          * **Safety**: If you try to access an index out of bounds (e.g. index 100 on a 3-element array), Ruby safely returns `nil` instead of raising an index-out-of-bounds exception!
          ```ruby
          letters = ["a", "b", "c"]
          letters[0]   # => "a"
          letters[-1]  # => "c" (last element)
          letters[100] # => nil (no exception)
          ```

          ### 3. Appending and Mutating (The Shovel Operator)
          To append elements to an array, you can use the shovel operator `<<` or `.push`. The shovel operator is a standard Ruby idiom.
          * **Mutations**: Methods like `push`, `pop`, `shift` (removes first), and `unshift` (adds to front) modify the original array in place.
          ```ruby
          nums = [1, 2]
          nums << 3      # nums becomes [1, 2, 3]
          nums.push(4)   # nums becomes [1, 2, 3, 4]
          nums.pop       # Returns 4, nums becomes [1, 2, 3]
          ```

          ### 4. Slicing with Ranges and Lengths
          You can retrieve sub-sections of arrays easily:
          * **Range slice**: `arr[start..end]` (inclusive range) or `arr[start...end]` (exclusive range).
          * **Offset slice**: `arr[start, length]` returns `length` elements starting from `start`.
          ```ruby
          chars = %w[a b c d e] # => ["a", "b", "c", "d", "e"]
          chars[1..3] # => ["b", "c", "d"]
          chars[2, 2] # => ["c", "d"]
          ```

          ### 5. Array Arithmetic and Set Operations
          Ruby arrays implement arithmetic operators like `+`, `-`, and `&` (intersection):
          * **Concatenation (`+`)**: Combines two arrays.
          * **Difference (`-`)**: Returns a copy of the first array removing elements present in the second.
          * **Intersection (`&`)**: Returns elements common to both arrays (without duplicates).
          ```ruby
          [1, 2] + [2, 3] # => [1, 2, 2, 3]
          [1, 2, 3] - [2] # => [1, 3]
          [1, 2] & [2, 3] # => [2]
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Implement `first_and_last(arr)` which returns a new array containing only the first and last elements of the input array.
          2. Implement `add_element(arr, el)` which appends `el` to the array `arr` and returns the updated array.
        MARKDOWN
        code_template: <<~RUBY,
          def first_and_last(arr)
            # Return a new array with the first and last element of 'arr'
          end
          
          def add_element(arr, el)
            # Append 'el' to array 'arr' and return it
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Method 'first_and_last' is not defined" unless respond_to?(:first_and_last)
          test_arr1 = [10, 20, 30, 40]
          res1 = first_and_last(test_arr1)
          raise "first_and_last([10, 20, 30, 40]) should return [10, 40], got \#{res1.inspect}" unless res1 == [10, 40]
          
          raise "Method 'add_element' is not defined" unless respond_to?(:add_element)
          test_arr2 = ["a", "b"]
          res2 = add_element(test_arr2, "c")
          raise "add_element(['a', 'b'], 'c') should return ['a', 'b', 'c'], got \#{res2.inspect}" unless res2 == ["a", "b", "c"]
        RUBY
        hint: "You can access the first element with arr[0] or arr.first, and the last with arr[-1] or arr.last. Use << to append."
      ),

      new(
        id: "iterators",
        title: "Enumerables & Iterators",
        level: "Level 2: Collections",
        description: "Learn how to use blocks to iterate, map, select, and reduce collections in a powerful way.",
        explanation: <<~MARKDOWN,
          # Enumerables & Iterators in Ruby

          The `Enumerable` mixin is one of Ruby's crown jewels. It provides a suite of traversal and search methods. Any class that implements the `each` method can mix in `Enumerable` to get these powers for free.

          Here are **5 detailed points** on using Enumerables like a senior Rubyist:

          ### 1. Side Effects vs Transformation (`each` vs `map`)
          * **`each`**: Used when you want to execute code for its *side effects* (like saving to a database, printing, or modifying global state). It returns the **original** array.
          * **`map` (or `collect`)**: Used when you want to *transform* every element. It yields each item to the block and returns a **new array** containing the block's return values.
          ```ruby
          [1, 2].each { |x| puts x } # Prints 1, 2. Returns [1, 2]
          [1, 2].map { |x| x * 2 }   # Returns [2, 4]
          ```

          ### 2. Filtering Collections (`select` vs `reject`)
          * **`select` (or `find_all`)**: Filters a collection by keeping elements that evaluate to `true` inside the block.
          * **`reject`**: The inverse of `select`. It discards elements that evaluate to `true` (keeping the false/nil ones).
          ```ruby
          numbers = [1, 2, 3, 4]
          numbers.select { |n| n.even? } # => [2, 4]
          numbers.reject { |n| n.even? } # => [1, 3]
          ```

          ### 3. Searching Collections (`find` / `detect`)
          If you only need a single element, use `find` (aliased as `detect`). It runs through the array and returns the **first** element that makes the block true, then stops searching immediately!
          ```ruby
          [1, 3, 4, 5].find { |n| n.even? } # => 4
          ```

          ### 4. Reduction & Aggregation (`reduce` / `inject`)
          `reduce` (aliased as `inject`) combines all elements of a collection by applying a binary operation, passed as a block or symbol.
          * **How it works**: It maintains an accumulator. For each element, it yields the accumulator and the element to the block, updating the accumulator with the block's return value.
          ```ruby
          # Sum array (starting accumulator at 0)
          sum = [1, 2, 3].reduce(0) { |acc, n| acc + n } # => 6
          
          # Shortcut passing symbol
          sum = [1, 2, 3].reduce(:+) # => 6
          ```

          ### 5. The Symbol-to-Proc Shorthand (`&:method`)
          When you want to call a single method on every element, you can use the shorthand symbol-to-proc syntax `&:method_name`.
          * **How it works**: Under the hood, this converts the symbol to a block that sends the method call to each yielded object.
          ```ruby
          # Long form
          %w[alice bob].map { |name| name.upcase } # => ["ALICE", "BOB"]
          # Short form
          %w[alice bob].map(&:upcase)              # => ["ALICE", "BOB"]
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Implement `double_numbers(numbers)` to return a new array with all numbers doubled, using `.map`.
          2. Implement `filter_even(numbers)` to return only the even numbers, using `.select`.
        MARKDOWN
        code_template: <<~RUBY,
          def double_numbers(numbers)
            # Use map to double all elements
          end
          
          def filter_even(numbers)
            # Use select to filter even elements
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Method 'double_numbers' is not defined" unless respond_to?(:double_numbers)
          res1 = double_numbers([2, 5, 10])
          raise "double_numbers([2, 5, 10]) should return [4, 10, 20], got \#{res1.inspect}" unless res1 == [4, 10, 20]
          
          raise "Method 'filter_even' is not defined" unless respond_to?(:filter_even)
          res2 = filter_even([1, 2, 3, 4, 5, 6])
          raise "filter_even([1, 2, 3, 4, 5, 6]) should return [2, 4, 6], got \#{res2.inspect}" unless res2 == [2, 4, 6]
        RUBY
        hint: "Remember to call map on the numbers array inside double_numbers: `numbers.map { |n| ... }`."
      ),

      new(
        id: "classes",
        title: "Object-Oriented Ruby",
        level: "Level 3: OOP",
        description: "Understand classes, instance variables, initializers, and attribute readers/writers.",
        explanation: <<~MARKDOWN,
          # Object-Oriented Ruby

          Ruby is a pure Object-Oriented language: **everything** is an object. Numbers (like `5`), strings, nil, and classes themselves are all fully instantiated objects.

          Here are **5 detailed points** explaining OOP architecture in Ruby:

          ### 1. Classes & Instantiation (`.new` & `initialize`)
          To create objects, you write a blueprint using the `class` keyword. 
          * **Instantiating**: You call `Class.new` (e.g. `User.new`), which allocates memory and automatically triggers the constructor method `initialize`.
          * **Arguments**: Any arguments passed to `.new` are passed directly to `initialize`.
          ```ruby
          class User
            def initialize(username)
              @username = username
            end
          end
          ```

          ### 2. Encapsulation & Instance Variable Scope
          In Ruby, instance variables (`@variables`) are **strictly encapsulated** (private by default). They cannot be accessed or modified from outside the object instance directly. To access them, you must write getter and setter methods.
          ```ruby
          class User
            def name; @name; end          # Getter
            def name=(val); @name = val; end # Setter
          end
          ```

          ### 3. Attribute Accessor Shortcuts (`attr_reader`, `attr_writer`, `attr_accessor`)
          Writing getters and setters is tedious. Ruby provides class macros to generate them dynamically:
          - `attr_reader :name` generates the getter `def name; @name; end`.
          - `attr_writer :name` generates the setter `def name=(val); @name = val; end`.
          - `attr_accessor :name` generates both getter and setter.
          ```ruby
          class User
            attr_accessor :name, :age # Creates getters and setters for both
          end
          ```

          ### 4. Single Inheritance & Overriding (`super`)
          Ruby supports **single inheritance**. A class can inherit state and behavior from a single parent class using the `<` symbol.
          * **`super`**: You can override a parent method and call the parent's version using the `super` keyword.
          ```ruby
          class Admin < User
            def initialize(name, role)
              super(name) # Calls User#initialize
              @role = role
            end
          end
          ```

          ### 5. Polymorphism & Duck Typing
          Ruby does not use interfaces or strict static typing. It uses **Duck Typing**: *"If it walks like a duck and quacks like a duck, we treat it as a duck."*
          * **Message Passing**: You can call any method on any object as long as that object responds to that method at runtime. This keeps object relationships highly flexible.
          ```ruby
          # We don't care about the type; we only care that 'logger' responds to 'log'
          def save_data(data, logger)
            logger.log("Saving data...") if logger.respond_to?(:log)
          end
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Create a `Developer` class.
          2. Give it `attr_accessor` for `name` and `role`.
          3. Implement an `initialize(name, role)` method to assign these.
          4. Implement a `greet` method that returns the string `"Hello, I am [name] and I work as a [role]!"`.
        MARKDOWN
        code_template: <<~RUBY,
          class Developer
            # Write your class definition here
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Class Developer is not defined" unless defined?(Developer) && Developer.is_a?(Class)
          dev = Developer.new("Jayesh", "Rails Intern")
          raise "Developer name is not readable" unless dev.respond_to?(:name)
          raise "Developer name is not writable" unless dev.respond_to?(:name=)
          raise "Developer role is not readable" unless dev.respond_to?(:role)
          
          raise "Developer name should be 'Jayesh', got \#{dev.name.inspect}" unless dev.name == "Jayesh"
          raise "Developer role should be 'Rails Intern', got \#{dev.role.inspect}" unless dev.role == "Rails Intern"
          
          dev.name = "Alex"
          raise "greet method not defined" unless dev.respond_to?(:greet)
          greeting = dev.greet
          expected = "Hello, I am Alex and I work as a Rails Intern!"
          raise "greet should return '\#{expected}', got \#{greeting.inspect}" unless greeting == expected
        RUBY
        hint: "Don't forget to use `attr_accessor :name, :role` at the top of your class, and interpolate variables in your greeting: `\"Hello, I am \#{name}...\"`."
      ),

      new(
        id: "blocks_procs_lambdas",
        title: "Blocks, Procs & Lambdas",
        level: "Level 3: OOP & Functions",
        description: "Understand closures in Ruby: how blocks yield code, and the differences between Procs and Lambdas.",
        explanation: <<~MARKDOWN,
          # Blocks, Procs & Lambdas

          Ruby is famous for its powerful implementation of closures. Let's look at how they work and how they differ from each other.

          Here are **5 detailed points** to master Ruby closures:

          ### 1. What is a Block? (Anonymous Closures)
          A block is a chunk of code wrapped in `do...end` or curly braces `{...}`. Blocks are not objects; they cannot be assigned to variables. They are passed to methods implicitly as arguments.
          ```ruby
          [1, 2].each { |x| puts x } # The block is { |x| puts x }
          ```

          ### 2. Yielding Control (`yield` and `block_given?`)
          Inside a method, you can execute a block using the `yield` keyword.
          * **Yield Params**: Any arguments passed to `yield` are forwarded to the block parameters.
          * **Safety**: If you use `yield` without passing a block, Ruby raises a `LocalJumpError`. Check for a block first using `block_given?`.
          ```ruby
          def run_twice
            if block_given?
              yield("First")
              yield("Second")
            end
          end
          run_twice { |step| puts "\#{step} run" }
          ```

          ### 3. Procs (First-Class Block Objects)
          A `Proc` (short for procedure) is a block of code saved into an object.
          * **First-Class**: Because they are objects, you can save Procs in variables, store them in arrays, and pass them as method arguments.
          * **Calling**: You execute a Proc using the `.call` method or the square bracket shortcut `[]`.
          ```ruby
          say_hi = Proc.new { |name| "Hi \#{name}" }
          say_hi.call("Alex") # => "Hi Alex"
          say_hi["Alex"]      # => "Hi Alex"
          ```

          ### 4. Lambdas (Strict Procs)
          Lambdas are a sub-species of Procs defined using `lambda { ... }` or the stabby lambda syntax `->(args) { ... }`.
          * **Strict Arguments**: Lambdas check the number of arguments passed to them. If you pass the wrong number, it raises `ArgumentError`. Procs ignore extra arguments and bind missing ones to `nil`.
          ```ruby
          my_lambda = ->(a, b) { a + b }
          my_lambda.call(1) # Raises ArgumentError!
          
          my_proc = Proc.new { |a, b| a.to_i + b.to_i }
          my_proc.call(1)  # Works (b becomes nil, converted to 0)
          ```

          ### 5. Control Flow: Return Behavior
          The most critical difference between a Proc and a Lambda is how the `return` keyword behaves:
          * **Lambdas**: A `return` inside a lambda returns control out of the **lambda itself** (acting like a normal function return).
          * **Procs**: A `return` inside a Proc returns from the **method/scope that defined the Proc**. If defined outside a method, it raises a `LocalJumpError`.
          ```ruby
          def proc_test
            p = Proc.new { return "proc exit" }
            p.call
            "method exit" # This line is NEVER reached!
          end
          
          def lambda_test
            l = -> { return "lambda exit" }
            l.call
            "method exit" # This line IS reached!
          end
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Implement a method `run_twice` that yields to a block exactly twice, but *only* if a block is given.
          2. Create a Lambda called `format_usd` (using `->` or `lambda`) that takes a number and returns a string starting with `$` and displaying 2 decimal places (e.g. `25` -> `"$25.00"`, `5.5` -> `"$5.50"`).
        MARKDOWN
        code_template: <<~RUBY,
          def run_twice
            # Yield to block twice if given
          end
          
          # Define format_usd lambda below
          format_usd = 
        RUBY
        validation_code: <<~RUBY,
          raise "Method 'run_twice' is not defined" unless respond_to?(:run_twice)
          counter = 0
          run_twice { counter += 1 }
          raise "run_twice should execute the block twice, counted: \#{counter}" unless counter == 2
          
          # Test if run_twice handles no block given case
          begin
            run_twice
          rescue LocalJumpError => e
            raise "run_twice should check block_given? before yielding, otherwise it raises LocalJumpError!"
          end
          
          raise "format_usd is not defined" unless binding.local_variable_defined?(:format_usd) || binding.eval("defined?(format_usd)")
          fmt = binding.eval("format_usd")
          raise "format_usd should be a Lambda or Proc" unless fmt.is_a?(Proc)
          
          # Check return format
          res1 = fmt.call(10)
          raise "format_usd(10) should return '$10.00', got \#{res1.inspect}" unless res1 == "$10.00"
          res2 = fmt.call(4.5)
          raise "format_usd(4.5) should return '$4.50', got \#{res2.inspect}" unless res2 == "$4.50"
        RUBY
        hint: "To format a float with 2 decimal places in Ruby, use string formatting: `'%.2f' % value`."
      ),

      new(
        id: "metaprogramming",
        title: "Metaprogramming Basics",
        level: "Level 4: Advanced Ruby",
        description: "Learn Ruby's magical powers: calling methods dynamically using send, and defining them using define_method.",
        explanation: <<~MARKDOWN,
          # Metaprogramming Basics in Ruby

          Metaprogramming is writing code that writes code dynamically at runtime. It is the core magic behind Rails features like dynamic model scopes, association helpers, and controllers.

          Here are **5 detailed points** on the mechanics of Ruby metaprogramming:

          ### 1. Dynamic Method Dispatch (`send`)
          In Ruby, calling a method is actually "sending a message" to an object. You can send a message dynamically by passing the method's name as a symbol or string to `.send`.
          * **Bypassing encapsulation**: `.send` bypasses private access control, allowing you to call private methods! If you want to respect private methods, use `.public_send`.
          ```ruby
          user = User.new("Bob")
          method_name = :name
          user.send(method_name) # Equivalent to user.name
          ```

          ### 2. Dynamic Methods (`define_method`)
          You can define methods programmatically using `define_method` inside a class body.
          * **Scope**: It takes a method name symbol and a block which is executed whenever the defined method is called.
          * **Rails Context**: Rails uses this to create active record attribute getters/setters based on database columns at startup.
          ```ruby
          class Device
            [:on, :off].each do |status|
              define_method("turn_\#{status}") do
                "Device is \#{status.to_s.upcase}"
              end
            end
          end
          ```

          ### 3. Dynamic Introspection (`respond_to?`)
          Because Ruby is highly dynamic, objects can gain and lose methods at runtime.
          * **Safety**: Before sending a dynamic message, check if the object supports it using `.respond_to?(method_name_symbol)`.
          ```ruby
          device = Device.new
          device.respond_to?(:turn_on) # => true
          ```

          ### 4. Intercepting Undefined Messages (`method_missing`)
          If an object receives a message it doesn't recognize, Ruby calls its `method_missing` method. By overriding this, you can catch undefined calls and handle them dynamically.
          * **Rails Context**: This is how dynamic finders like `User.find_by_name_and_email` are implemented! Rails intercepts the call, parses the method name, and runs the query.
          ```ruby
          class CatchAll
            def method_missing(method_name, *args, &block)
              "You tried to call \#{method_name} with \#{args}"
            end
            
            # Good practice: Always override respond_to_missing? when overriding method_missing
            def respond_to_missing?(method_name, include_private = false)
              true
            end
          end
          ```

          ### 5. Open Classes (Monkey Patching)
          In Ruby, class definitions are not closed. You can reopen any existing class (even standard libraries like `String` or `Integer`) at runtime and inject new methods.
          * **Warning**: While powerful, this can lead to conflicts if two libraries attempt to define the same method name.
          ```ruby
          class String
            def loud
              self.upcase + "!!!"
            end
          end
          "hello".loud # => "HELLO!!!"
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Complete the `SmartDevice` class by dynamically defining two methods: `turn_on` (returns `"Device is ON"`) and `turn_off` (returns `"Device is OFF"`), using `define_method` inside a loop.
          2. Complete the `call_turn_on(device)` method to call the `turn_on` method on the `device` object dynamically using `send`.
        MARKDOWN
        code_template: <<~RUBY,
          class SmartDevice
            # Loop over status values and dynamically define turn_on and turn_off
            [:on, :off].each do |status|
              # define_method(...) do ... end
            end
          end
          
          def call_turn_on(device)
            # Call 'turn_on' dynamically using send
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Class SmartDevice is not defined" unless defined?(SmartDevice) && SmartDevice.is_a?(Class)
          device = SmartDevice.new
          raise "turn_on method should be defined on SmartDevice" unless device.respond_to?(:turn_on)
          raise "turn_off method should be defined on SmartDevice" unless device.respond_to?(:turn_off)
          
          val_on = device.turn_on
          val_off = device.turn_off
          raise "turn_on should return 'Device is ON', got \#{val_on.inspect}" unless val_on == "Device is ON"
          raise "turn_off should return 'Device is OFF', got \#{val_off.inspect}" unless val_off == "Device is OFF"
          
          raise "Method 'call_turn_on' is not defined" unless respond_to?(:call_turn_on)
          res = call_turn_on(device)
          raise "call_turn_on(device) should return 'Device is ON', got \#{res.inspect}" unless res == "Device is ON"
        RUBY
        hint: "Inside define_method, status will be :on or :off. You can convert it to string and format it: `'Device is ' + status.to_s.upcase`."
      ),

      new(
        id: "rails_idioms",
        title: "Rails Ruby Idioms & ActiveSupport",
        level: "Level 5: Ruby in Rails",
        description: "Learn how Rails extends Ruby under the hood and master core ActiveSupport helpers like blank?, presence, and Safe Navigation.",
        explanation: <<~MARKDOWN,
          # Rails Ruby Idioms & ActiveSupport

          ActiveSupport is the component of Ruby on Rails that extends the Ruby standard library with convenient methods, string transformations, and helper tools.

          Here are **5 detailed points** explaining the most common Ruby idioms inside Rails:

          ### 1. Object Evaluation: `.blank?` vs `.present?`
          Rails extends `Object` with presence query methods to replace complex checks:
          * **`.blank?`**: Returns `true` if an object is `nil`, `false`, an empty string, an empty array/hash, or a string containing only whitespace.
          * **`.present?`**: The exact opposite of `.blank?`.
          ```ruby
          # Without Rails:
          if name.nil? || name.strip.empty?
          # With Rails:
          if name.blank?
          ```

          ### 2. Streamlining Defaults using `.presence`
          The `.presence` helper returns the object itself if it is `.present?`, otherwise it returns `nil`. This is highly useful for cleaning params and setting clean fallbacks using the `||` operator.
          ```ruby
          # Without .presence:
          display_name = params[:name].present? ? params[:name] : "Guest"
          
          # With .presence:
          display_name = params[:name].presence || "Guest"
          ```

          ### 3. Safe Navigation Operator (`&.`)
          Introduced in Ruby 2.3, the Safe Navigation Operator `&.` prevents your code from throwing a `NoMethodError: undefined method ... for nil:NilClass` when querying properties on objects that might be `nil`.
          * **How it works**: If the receiver is `nil`, it skips the method call and returns `nil` safely.
          ```ruby
          # Without Safe Navigation (crashes if user is nil):
          user.profile.name
          
          # With Safe Navigation (safely returns nil if user or profile is nil):
          user&.profile&.name
          ```

          ### 4. ActiveSupport String Inflections
          Rails extends the `String` class with inflection helpers to handle grammatical pluralization and code-style formatting:
          * **Pluralization**: `.pluralize`, `.singularize`.
          * **Naming Transformations**: `.camelize`, `.underscore`, `.classify`.
          ```ruby
          "developer".pluralize  # => "developers"
          "admin_user".camelize  # => "AdminUser"
          "AdminUser".underscore # => "admin_user"
          ```

          ### 5. Declaring Method Delegation (`delegate`)
          Rails provides a class macro `delegate` to implement the Law of Demeter, allowing you to delegate method calls from one object to an associated object automatically.
          * **Cleaner calls**: Keeps code clean by avoiding long chaining like `user.profile.zipcode` in favor of `user.zipcode`.
          ```ruby
          class User < ApplicationRecord
            has_one :profile
            # Automatically defines User#zipcode to fetch it from profile
            delegate :zipcode, to: :profile, allow_nil: true
          end
          ```

          ---

          ### Let's Practice!
          Your goal is to:
          1. Implement `clean_params(params)` that returns the parameter hash itself if it is `.present?`, otherwise returns `nil`. (Hint: use `.presence`).
          2. Implement `safe_user_name(user)` that safely queries a user object:
             - If the user is present and has a name (which is not blank), return the name converted to uppercase.
             - If the user is nil or their name is blank/nil, return `"ANONYMOUS"`.
             - Use safe navigation `&.` and `.blank?` to write clean, crash-proof code.
        MARKDOWN
        code_template: <<~RUBY,
          def clean_params(params)
            # Use ActiveSupport's .presence helper
          end
          
          def safe_user_name(user)
            # Safely return user's uppercase name or "ANONYMOUS"
          end
        RUBY
        validation_code: <<~RUBY,
          raise "Method 'clean_params' is not defined" unless respond_to?(:clean_params)
          raise "clean_params should return nil for empty hash" unless clean_params({}).nil?
          raise "clean_params should return nil for nil" unless clean_params(nil).nil?
          raise "clean_params should return the parameters if present" unless clean_params({ name: "Jayesh" }) == { name: "Jayesh" }
          
          raise "Method 'safe_user_name' is not defined" unless respond_to?(:safe_user_name)
          
          # Create mock user struct
          UserMock = Struct.new(:name)
          u1 = UserMock.new("Jayesh")
          u2 = UserMock.new("")
          u3 = UserMock.new(nil)
          u4 = nil
          
          res1 = safe_user_name(u1)
          raise "safe_user_name(u1) should return 'JAYESH', got \#{res1.inspect}" unless res1 == "JAYESH"
          
          res2 = safe_user_name(u2)
          raise "safe_user_name(u2) should return 'ANONYMOUS', got \#{res2.inspect}" unless res2 == "ANONYMOUS"
          
          res3 = safe_user_name(u3)
          raise "safe_user_name(u3) should return 'ANONYMOUS', got \#{res3.inspect}" unless res3 == "ANONYMOUS"
          
          res4 = safe_user_name(u4)
          raise "safe_user_name(u4) should return 'ANONYMOUS', got \#{res4.inspect}" unless res4 == "ANONYMOUS"
        RUBY
        hint: "Remember: `user&.name` returns nil safely if user is nil. You can check if the name is blank with `&.blank?`."
      )
    ]
  end
end
