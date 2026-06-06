# Rubydojo 💎

An interactive Ruby learning roadmap, playground, and compiler built directly into your Rails application. Designed to accelerate the onboarding and training of interns and junior developers in modern Ruby conventions and Rails-specific idioms.

---

## Features 🚀

- **Interactive Learning Roadmap**: A beautifully styled, interactive visual timeline nodes to track lesson completion progress.
- **Embedded Sandbox Compiler**: Run and execute Ruby code in real-time inside a custom isolated evaluation class context—no global namespace pollution or warning logs.
- **Simulated Terminal Console**: An elegant, retro-modern dark chestnut terminal that prints live output, compilation results, and detailed validator feedback.
- **7 In-Depth, Structurally Rich Lessons**: Each lesson includes a comprehensive **5-point guide** covering core principles, common pitfalls, and Rails/enterprise-grade practices.
- **Royal Red & Beige Theme**: Designed to feel premium, royal, and clean, using an Outfit/Inter typography hierarchy, ivory backgrounds, and subtle Ruby-red highlights.
- **API-Only App Support**: Includes self-contained, direct asset serving that works out-of-the-box in API-only Rails applications without needing Sprockets or Propshaft.

---

## Curriculum Outline 📚

1. **Variables & Constants** (Naming conventions, scope levels, and Ruby's constant reassignment warning system)
2. **Collections & Arrays** (Slicing, negative indices, mutating shovel operations, and index safety)
3. **Hashes & Symbols** (Memory allocation advantages of symbols, keyword arguments, and hash manipulation)
4. **Blocks, Procs & Lambdas** (Yielding control, `block_given?`, and argument checking/return behavior differences)
5. **Object-Oriented Programming** (Classes, `attr_accessor`, module mixins, and inheritance)
6. **Metaprogramming** (Dynamic dispatch using `send`, and defining dynamic methods with `define_method`)
7. **Rails Ruby Idioms & ActiveSupport** (Open classes/monkey patching, `blank?` vs `present?`, and the safe navigation operator `&.`)

---

## Installation 📦

Add this line to your application's `Gemfile` (typically inside the `:development` group):

```ruby
group :development do
  gem "rubydojo"
end
```

And then execute:

```
bundle install
```

Configuration ⚙️
Mount the engine inside your Rails application's config/routes.rb:

```
Rails.application.routes.draw do
  # Mount Rubydojo under the path of your choice
  mount Rubydojo::Engine => "/rubydojo"
  
  # Your other routes...
end
```

How to Use 🎯

1. Start your Rails server:
```
  rails server
```

2. Navigate to http://localhost:3000/rubydojo in your browser.
3. Select a node from the interactive Roadmap to begin a lesson.
4. Read the detailed 5-point explanation, complete the practice task in the code editor, and click Validate Solution to advance.

Contributing 🤝
Contributions are welcome! Please feel free to submit issues or pull requests to improve lesson content, design, or safety isolation:

Fork the repository (https://github.com/J14as/rubydojo/fork).
Create your feature branch (git checkout -b feature/amazing-feature).
Commit your changes (git commit -m 'Add some amazing feature').
Push to the branch (git push origin feature/amazing-feature).
Open a Pull Request.

---
Made with pure intensions to help new comers! 
---

License 📄
The gem is available as open source under the terms of the MIT License.
