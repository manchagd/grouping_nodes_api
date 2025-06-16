# API Testing & Development Practices

## Test Coverage
- **Testing Framework**: The project uses **RSpec** as the main testing framework.

- **Coverage Tool**: **SimpleCov** is integrated to track code coverage.
  - Current test coverage exceeds **99%**.
  - Minimum acceptable threshold is **95%**.
  - Coverage reports are reviewed regularly.


## Test Factories & Data
- **FactoryBot** is used to generate consistent and reusable test data across models.

- **Faker** assists in producing realistic values for attributes like names and codes.


## Static Analysis & Linting
- **Rubocop** is used for static code analysis and style enforcement.

## Matchers & Helpers
- **Shoulda Matchers** provides concise one-liners to test common Rails model behaviors and validations.


## Debugging & Inspection
- **Pry** and debug tools are available for interactive debugging and introspection during test runs.

## Continuous Validation
- All tests **must pass** before deployment.
- Every new feature or fix **must include related specs**.
- **Pull requests are reviewed** to ensure new logic is covered and properly tested.

## Running Tests
To run the full test suite, including coverage reporting:
```bash
bundle exec rspec
```

To run a specific test file:
```bash
bundle exec rspec spec/models/node_spec.rb
```

To run a single example within a file:
```bash
bundle exec rspec spec/models/node_spec.rb:42
```

After running, a coverage report will be generated in the `coverage/` directory. Open `coverage/index.html` in your browser to view detailed metrics.

## Development Status
This API is currently under active development. New features and improvements are expected. Please refer to the changelog or version history for updates.

