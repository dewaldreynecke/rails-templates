run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# Gemfile
inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
    gem "devise"
    gem "autoprefixer-rails"
    gem "simple_form", github: "heartcombo/simple_form"

  RUBY
end

inject_into_file "Gemfile", after: 'gem "debug", platforms: %i[ mri mingw x64_mingw ]' do
  "\n  gem \"dotenv-rails\""
end

gsub_file("Gemfile", '# gem "sassc-rails"', 'gem "sassc-rails"')

# Layout
gsub_file(
  "app/views/layouts/application.html.erb",
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'
)

# Flashes
file "app/views/shared/_flashes.html.erb", <<~HTML
  <% if notice %>
    <div>
      <%= notice %>
    </div>
  <% end %>
  <% if alert %>
    <div>
      <%= alert %>
    </div>
  <% end %>
HTML

inject_into_file "app/views/layouts/application.html.erb", after: "<body>" do
  <<~HTML
    <%= render "shared/flashes" %>
  HTML
end

# Seed file split
run "mkdir db/seeds"

create_file 'db/seeds/development.rb', <<~TXT
  # Add the seed actions for the development environment to this file.

  puts "Development seed running."

  # ---------------------- Add your seed code in this block ----------------------

  # ------------------------------------------------------------------------------

  puts "Development seed complete."
TXT

create_file 'db/seeds/production.rb', <<~TXT
  # Add the seed actions for the production environment to this file.

  puts "Production seed running."

  # ---------------------- Add your seed code in this block ----------------------

  # ------------------------------------------------------------------------------

  puts "Production seed complete."
TXT

create_file 'db/seeds/test.rb', <<~TXT
  # Add the seed actions for the test environment to this file.

  puts "Test seed running."

  # ---------------------- Add your seed code in this block ----------------------

  # ------------------------------------------------------------------------------

  puts "Test seed complete."
TXT

run "rm db/seeds.rb"

create_file 'db/seeds.rb', <<~RUBY
  puts "Starting database seed."
  puts "Current environment is: \#{Rails.env.downcase}"
  load(Rails.root.join( 'db', 'seeds', "\#{Rails.env.downcase}.rb"))

  # Do not add any seed command to this file. Instead, go to /db/seeds/ where you will find:
  # development.rb
  # production.rb
  # test.rb
  # Add your seed code into one of those depending on the environment where you wish for it to execute.
RUBY

# After bundle
after_bundle do
  # Generators: db + simple form + pages controller
  rails_command "db:drop db:create db:migrate"
  generate("simple_form:install")
  generate(:controller, "pages", "home", "--skip-routes", "--no-test-framework")

  # Routes
  route 'root to: "pages#home"'

  # Gitignore
  append_file ".gitignore", <<~TXT
    # Ignore .env file containing credentials.
    .env*

    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
  TXT

  # Devise install + user
  generate("devise:install")
  generate("devise", "User")

  # Application controller
  run "rm app/controllers/application_controller.rb"
  file "app/controllers/application_controller.rb", <<~RUBY
    class ApplicationController < ActionController::Base
      before_action :authenticate_user!
    end
  RUBY

  # migrate + devise views
  rails_command "db:migrate"
  generate("devise:views")
  gsub_file(
    "app/views/devise/registrations/new.html.erb",
    "<%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>",
    "<%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: :false }) do |f| %>"
  )
  gsub_file(
    "app/views/devise/sessions/new.html.erb",
    "<%= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>",
    "<%= simple_form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: :false }) do |f| %>"
  )
  link_to = <<~HTML
    <p>Unhappy? <%= link_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>
  HTML
  button_to = <<~HTML
    <div class="d-flex align-items-center">
      <div>Unhappy?</div>
      <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-link" %>
    </div>
  HTML
  gsub_file("app/views/devise/registrations/edit.html.erb", link_to, button_to)

  # Pages Controller
  run "rm app/controllers/pages_controller.rb"
  file "app/controllers/pages_controller.rb", <<~RUBY
    class PagesController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :home ]

      def home
      end
    end
  RUBY

  # Environments
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: "development"
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: "production"

  # Heroku
  run "bundle lock --add-platform x86_64-linux"

  # Dotenv
  run "touch '.env'"

  # Rubocop
  run "curl -L https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/.rubocop.yml > .rubocop.yml"

  # Git
  git :init
  git add: "."
  git commit: "-m 'Rails new with https://github.com/dewaldreynecke/rails-templates (Minimal with authentication)'"
end
