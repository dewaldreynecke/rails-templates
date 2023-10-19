run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# Gemfile
inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
    gem "devise"
    gem "simple_form", github: "heartcombo/simple_form"

  RUBY
end

# Layout
gsub_file(
  "app/views/layouts/application.html.erb",
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'
)

# Prepare to be able to add Tailwind classes to the <html> and <body> tags
inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
  <<~RUBY
    \tdef body_class(class_name="")
      \tcontent_for :body_class, class_name
    \tend

    \tdef html_class(class_name="")
      \tcontent_for :html_class, class_name
    \tend
  RUBY
end

gsub_file(
  'app/views/layouts/application.html.erb',
  '<html>',
  '<html class="<%= yield (:html_class) %>">'
)

gsub_file(
  'app/views/layouts/application.html.erb',
  '<body>',
  '<body class="<%= yield (:body_class) %>">'
)

# Flashes
file "app/views/shared/_flashes.html.erb", <<~HTML
<% if notice %>
  <div class="rounded-md bg-green-50 p-4" data-controller="flashes" data-flashes-target="notification" data-turbo-temporary>
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm font-medium text-green-800"><%= notice %></p>
      </div>
      <div class="ml-auto pl-3">
        <div class="-mx-1.5 -my-1.5">
          <button type="button" class="inline-flex rounded-md bg-green-50 p-1.5 text-green-500 hover:bg-green-100 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2 focus:ring-offset-green-50" data-action="click->flashes#close">
            <span class="sr-only">Dismiss</span>
            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
<% end %>

<% if alert %>
  <div class="rounded-md bg-red-50 p-4" data-controller="flashes" data-flashes-target="notification" data-turbo-temporary>
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm font-medium text-red-800"><%= alert %></p>
      </div>
      <div class="ml-auto pl-3">
        <div class="-mx-1.5 -my-1.5">
          <button type="button" class="inline-flex rounded-md bg-red-50 p-1.5 text-red-500 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-600 focus:ring-offset-2 focus:ring-offset-red-50" data-action="click->flashes#close">
            <span class="sr-only">Dismiss</span>
            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
<% end %>
HTML

inject_into_file "app/views/layouts/application.html.erb", before: "<%= yield %>" do
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
  # route 'root to: "pages#home"'
  gsub_file(
    "config/routes.rb",
    '# root "posts#index"',
    'root to: "pages#home"'
  )

  # Gitignore
  append_file ".gitignore", <<~TXT

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

  # migrate + generate, update, and style devise views
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

  inject_into_file "app/views/devise/sessions/new.html.erb", before: "<h2>Log in</h2>" do
    <<~RUBY
      <% html_class "h-full bg-gray-50" %>
      <% body_class "h-full" %>

    RUBY
  end

  # Pages Controller
  run "rm app/controllers/pages_controller.rb"
  file "app/controllers/pages_controller.rb", <<~RUBY
    class PagesController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :home ]

      def home
      end
    end
  RUBY

  # Stimulus controller for the Flashes
  generate "stimulus", "flashes"

  inject_into_file "app/javascript/controllers/flashes_controller.js", after: "export default class extends Controller {\n" do <<~JAVASCRIPT
      static targets = ["notification"]

        close() {
          this.notificationTarget.classList.add("hidden")
        }
    JAVASCRIPT
  end

  # Environments
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: "development"
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: "production"

  # Dotenv
  run "touch '.env'"

  # Rubocop
  run "curl -L https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/.rubocop.yml > .rubocop.yml"

  # Git
  git :init
  git add: "."
  git commit: "-m 'Rails new with https://github.com/dewaldreynecke/rails-templates (Propshaft & Tailwind)'"
end
