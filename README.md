# AnniversaryApp

This program assists supervisors in tracking upcoming anniversaries for their employees.

The program uses a CSV file with the following format:

- `employee_id,first_name,last_name,hire_date,supervisor_id`

To run the program, follow the following instrcutions:

1. Run `asdf install` (Don't have asdf, install from [here](https://asdf-vm.com/guide/getting-started.html))
2. `mix deps.get` (from root directory) to install Elixir dependencies
3. `mix anniversary <input_file_path> <run_date>` to run generate a response with the 5 upcoming anniversary dates closest to the `run_date` in a JSON response
