# AnniversaryApp

This program assists supervisors in tracking upcoming anniversaries for their employees.

The program uses a CSV file with the following format:

- `employee_id,first_name,last_name,hire_date,supervisor_id`

## Running the App

To run the program, follow the following instrcutions:

1. Run `asdf install` (Don't have asdf, install from [here](https://asdf-vm.com/guide/getting-started.html))
2. `mix deps.get` (from root directory) to install Elixir dependencies
3. `mix anniversary <input_file_path> <run_date>` to run generate a list of supervisors (and employees) where the supervisors have up to 5 of their reports listed who have upcoming 5 year anniversary dates (closest to the `run_date`) in a JSON response.

## Testing and Code Quality

- Run `mix test` to run all of the tests
- Run `mix credo` to run code linting checks (runs in strict mode as default)
- Run `mix dialyzer` for type checking

## Notes on Coding Challenge

The primary purpose of this challenge was to create the list of anniversary employees per supervisor based on an input CSV file. There was a lot of additional time/effort put into handling edge case concerns regarding improper application start calls, malformed data, or invalid files. The intent of the coding challenge was to complete work in no more than 4 hours, but the work to handle all of the edge cases and properly test doubled that time. In normal scenarios, this work could have been skipped to finish in under 4 hours (assuming that this would be an internal tool and the edge case concerns were not worth addressing based on time constraints). I chose to spend the time building out a more robust solution because I wanted to have a better respresentation of a realistic application build (and I felt handling edge cases presented a better representation of coding ability).

Concerning optimization, while this task could have been performed in with less iterations through the data (build the supervisor JSON response directly from the data from the CSV parsing library), this would have produced a much harder to understand solution (and would have made edge case handling more challenging to write and test). I chose to build a list of Employee structs as a intermediate step for clarity and ease of testing. This also presents a clean seam for inserting persistence if it was decided to store the records in a database and use SQL queries to due the heavy lifting of building the upcoming anniversary lists (which would be more efficient). Side note on a persisted solution, I would chose to also create a "supervisors" table with a 1 to many relationship to "employees" to avoid table inheritance issues. I also chose to build the supervisors map as an additional step prior to JSON conversion to mimic what normally would be found in a view function if working with an API controller. Since a list of employees is not expected to be very large, I chose to add extra iterations to improve the testing assertions and provide additional seams for situations where different responses might be necessary (more data from employee record). The order_data function could just as easily have returned a map (or even the JSON response) to save iterations at the cost of testing ease and some readability.

**Note:** There is test flakiness with the first 2 tests in anniversary_test due to the direct assertion of an ordered JSON response where the :employee_id and :anniversary_date map usage does not guarantee order (so occassionally the anniversary_date comes before the employee_id). Using data structures to ensure ordering (like Keyword lists with a Tuple Jason.Encoder) would ensure ordering but make the JSON response not match the desired format. I chose to leave the current implementation.
