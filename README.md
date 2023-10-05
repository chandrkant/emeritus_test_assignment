##### Emeritus Test Assignment

# Project Overview:

    The project's primary goal is to create a versatile application that empowers users to efficiently create and oversee educational institutions, courses, class groups, and students. It accommodates a diverse range of user roles, including administrators, school administrators, and students, delivering a secure and adaptable platform tailored to the unique needs of educational organizations.

    User Types and Responsibilities:

    # Admin:

    * Admins have full control over the system.
    * They can create schools and School Admin accounts.
    * Admins are responsible for overall system administration and management.


    # SchoolAdmin:

    * SchoolAdmins can update information about the school.
    * They are responsible for creating courses offered by the school.
    * SchoolAdmins can create and manage batches for different courses.
    * SchoolAdmins can review and approve/deny enrollment requests made by students.

    # Student:

    * Students can raise a request to enroll in a specific batch.
    * They can check classmates within the same batch.

##### For checking security vulnerabilty

We have added brakeman gem with [brakeman-report](https://github.com/chandrkant/emeritus_test_assignment/blob/main/output_file.html)

##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.2.1](https://github.com/chandrkant/emeritus_test_assignment/blob/main/.ruby-version)
- Rails [6.1.7](https://github.com/chandrkant/emeritus_test_assignment/blob/main/Gemfile)

##### 1. Check out the repository

```bash
git clone git@github.com:chandrkant/emeritus_test_assignment.git
```

##### 2. Navigate to the project directory

```bash
cd emeritus_test_assignment
```

##### 3. Run bundle

```bash
bundle install
```

##### 4. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 5. Run the test suite

```ruby
bundle exec rspec
```

##### 6. Start the Rails server

You can start the rails server using the command given below.

```ruby
bin/rails server
```

And now you can visit the site with the URL http://localhost:2350

## Contact

Chandrakant Solanki: jraman05@gmail.com

# Emeritus Test Assignment
