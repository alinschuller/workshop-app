# dry-rb/rom-rb workshop app

This is the companion app for 2017's series of [dry-rb](http://dry-rb.org/) and [rom-rb](http://rom-rb.org/) workshops conducted by [Tim Riley](https://github.com/timriley).

Follow the instructions and complete the exercises below to get to know dry-rb and rom-rb, and eventually put together a complete, working app.

## Requirements

- git 1.7.0 or newer
- A recent version of Ruby (2.3.x or 2.4.x)
- PostgreSQL

## First steps

Clone this repository:

```sh
$ git clone https://github.com/dry-rb/workshop-app
```

Set up the app:

```sh
$ ./bin/setup
```

Run the app:

```
$ bundle exec shotgun -p 3000 -o 0.0.0.0 config.ru
```

Then browse the app at [localhost:3000](http://localhost:3000).

# Exercises

Each exercise topic focuses on a specific area of the dry-rb/rom-rb stack, and is intended to follow an introduction to the topic as part of the workshop.

## ✏️ Types & validation

Merge the starter code:

```sh
$ git merge --no-edit -s recursive -X theirs 1-types-validation
```

Run the specs:

```sh
$ bundle exec rspec
```

There should be failures for examples in the following files:

```
./spec/unit/types/article_status_spec.rb
./spec/unit/entities/article_spec.rb
./spec/admin/unit/articles/form_schema_spec.rb
```

### Types

- [x] Make a strict string enum type called `ArticleStatus`

### Structs

- [x] Make an `Article` struct class with the following atributes
  - `title` (strict string)
  - `status` (`ArticleStatus`)
  - `published_at` (optional strict time)

### Validation

- [x] Update `Admin::Articles::FormSchema` to validate input to match the `Article` struct attributes
- [x] Add a high-level rule to validate that `published_at` is filled only when `status` is set to "published"

After completing these exercises, re-run the specs and ensure they're all passing.

### In practice

- Think of some examples of where and how these would have helped in your own applications:
  - [x] Types
  - [x] Typed structs or value objects
  - [x] Standalone validation schemas

### Further exploration

#### Types

- [x] Type with default
- [x] Constrained type using predicates
- [x] Type with custom constructor

#### Validation

- [x] Use a custom predicate (with custom error message)
- [x] Write a schema for nested data
- [x] Write a high-level validation block

If you need to catch up, merge the completed work:

```sh
$ git merge --no-edit -s recursive -X theirs 1-types-validation-completed
```

## ✏️ Functional objects & systems

Merge the starter code and run the specs:

```sh
$ git merge --no-edit -s recursive -X theirs 2-functional-objects-and-systems
$ bundle exec rspec
```

There should be failures for examples in this file:

```
./spec/admin/unit/articles/create_spec.rb
```

### Building a functional object

- [x] Create a functional operation class for creating an article, in `apps/admin/lib/blog/admin/articles/create.rb`
- [x] Define a `#call` method accepting article params
- [x] Use the `FormSchema` we already created to validate these params
- [x] Create a dummy article repository class (with a `#create` method) at `apps/admin/lib/blog/admin/article_repo.rb`
- [x] Inject the article_repo into the `Articles::Create` functional object
- [x] When article params are valid, create an article using the repo and return it wrapped in a `Right`
- [x] When article params are invalid, return the validation result wrapped in a `Left`

### Inspecting the system

- Inspect the `Blog::Admin::Container` system container
  - [x] Open the console and inspect its `.keys`
  - [x] Resolve an `articles.create` object from the container
  - [x] Call the object with valid/invalid attributes to inspect its output
- Inspect the behavior of a non-finalized container
  - [x] Comment out the code that finalizes the container (in `apps/admin/system/boot.rb`)
  - [x] Open the console and inspect the container's `.keys`
  - [x] Count the number of loaded Ruby source files (via `$LOADED_FEATURES.grep(/workshop-app/).count`)
  - [x] Initialize an `Admin::Articles::Create` object directly
  - [x] Inspect the container's `.keys` again
  - [x] Count the number of loaded Ruby source files again (via `$LOADED_FEATURES.grep(/workshop-app/).count`)

### In practice

- [x] Think of how something you've written before could be modelled as functional objects
- [x] Think of something you've written that would have been better broken up into smaller units of responsibility

If you need to catch up, merge the completed work:

```sh
$ git merge --no-edit -s recursive -X theirs 2-functional-objects-and-systems-completed
```

## ️✏️ Persistence with rom-rb

Merge the starter code:

```sh
$ git merge --no-edit -s recursive -X theirs 3-persistence
```

Migrate the database:

```sh
$ bundle exec rake db:migrate
$ RACK_ENV=test bundle exec rake db:migrate
```

Run the specs:

```sh
$ bundle exec rspec
```

There should be failures for examples in this file:

```
./spec/admin/unit/article_repo_spec.rb
```

### Getting acquainted

Inspect the basic setup:

- [x] Bootable component in `system/boot/persistence.rb`
- [x] Migrations in `db/migrate`
- [x] Relations in `lib/persistence/relations`
- [x] Test factories in `spec/factories`
- [x] Articles repo at `apps/admin/lib/admin/persistence/articles_repo.rb`

### Reading data

- [x] Define an "author" association on articles
  - [x] Specify a `belongs_to :author` association in articles relation
  - [x] Update `spec/factories/articles.rb` to include this association
- [x] Add `#by_pk` to repo for reading individual records
- [x] Add `#listing` to repo for reading lists of articles
  - [x] Order articles by created_at time descending
  - [x] Aggregate articles with their author

### Writing data

- [x] Enable `create` command on repo
- [x] Enable `update` command on repo using `by_pk` restriction
- [x] Test writing/reading/updating article records from the console

### Refactoring

- [ ] Return results as custom structs via a custom struct namespace
- [ ] Move lower-level query methods into relation
- [ ] Create shared method in repository to ensure all results return

### Further exploration

- [ ] Return results as wrapped in custom classes via `.as`
- [ ] Investigate using dry-struct to build custom struct classes with strict attribute types
- [ ] Build and use a custom changeset to transform data before writing

If you need to catch up, merge the completed work:

```sh
$ git merge --no-edit -s recursive -X theirs 3-persistence-completed
```

## ️✏️ Views & routes

Merge the starter code and run the specs:

```sh
$ git merge --no-edit -s recursive -X theirs 4-routes-views
$ bundle exec rspec
```

There should be failures for examples in this file:

```
./spec/main/unit/views/home_spec.rb
```

- [x] Set up the `Blog::Main::Views::Home` view controller:
  - [x] Inject an `article_repo` dependency
  - [x] Add an `articles` exposure returning `articles_repo.listing`
- [x] Add the `#listing` method to `Blog::Main::ArticleRepo` (return published articles only, ordered by `published_at` descending)
- [x] Fill in `web/templates/home.html.slim` template so it displays each article
- [x] Test your work by running the app and viewing it in the browser

If you need to catch up, merge the completed work:

```sh
$ git merge --no-edit -s recursive -X theirs 4-routes-views-completed
```

## ️✏️ Next steps

This is just the beginning of working app. We can do more!

- Add individual article pages to the public area
  - `articles/:id`
- Add article management to the admin area:
  - `admin/articles`
  - `admin/articles/new`
  - `admin/articles/:id/edit`
- Add user authentication to the admin area
