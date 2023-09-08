# Dewald's Rails templates

Use these [Rails Templates](http://guides.rubyonrails.org/rails_application_templates.html)
to generate new Rails 7 apps.

I make these for my own use and thus add here from time to time. I will never
change an older one (in case someone likes to use it), except for making the README
nicer or bug fixes. New ones to the top of this README.

## With propshaft and Bulma (incl Devise auth)

| Created | Last update |
| -- | -- |
| 8 September 2023 | 8 September 2023 |

A Rails app with Devise for user authentication that sets up the following:
- Propshaft for the asset pipeline
- ESBuild to transpile the Javascript
- [Bulma](https://bulma.io) as the CSS framework (Sass)
- PostgreSQL database in Development and Production
- Adds gem: [Simple form (without Bootstrap)](https://github.com/heartcombo/simple_form)
- Adds gem: [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails)
- Adds gem: dotenv-rails
- Creates alert messages for Devise notices and styles them with Bulma to appear
at the bottom right of the window with a Stimulus controller to handle a click
on the close button.
- Splits seed file for Development, Production, and Test environments. [Read more about it here.](https://blog.dewaldreynecke.net/entries/rails-seed-by-enviroment)

### Already done
- Database created and migrated
- Devise views copied to app so you can modify them
- git is initialised
- .gitignore updated to take care of .DS_Store and .env files
- Pages controller updated, with home page set as root in routes.rb

### To do afterwards
- Configure Action Mailer production url in /config/environments/production.rb on line 4
- Add git remote and push

### Commands

```bash
rails new \
  -d postgresql \
  -j esbuild \
  --css bulma \
  -a propshaft \
  -m https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/propshaft.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
Run your local development server with
```bin/dev```

## Webpack with authentication

| Created | Last update |
| -- | -- |
| 13 July 2023 | 13 July 2023 |

Same as _Mininal with authentication_ but adds Webpack to handle bundling.
This is not ideal in 2023, but it works. **I advise you to not use it.**

```bash
rails new \
  -d postgresql \
  -j webpack \
  -m https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/auth.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
Run your local development server with
```bin/dev```
to take care of both the rails server and webpack.

## Minimal with authentication

| Created | Last update |
| -- | -- |
| 7 July 2023 | 11 July 2023 |

A minimum Rails app with Devise for user authentication that sets up the following:
- PostgreSQL database in Development and Production
- Adds gem: [Simple form (without Bootstrap)](https://github.com/heartcombo/simple_form)
- Adds gem: [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails)
- Adds gem: dotenv-rails
- Enables gem: sassc-rails
- Creates alert messages for Devise notices and alerts (see to do below)
- Splits seed file for Development, Production, and Test environments. [Read more about it here.](https://blog.dewaldreynecke.net/entries/rails-seed-by-enviroment)

```bash
rails new \
  -d postgresql \
  -m https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/auth.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

**Already done**
- Database created and migrated
- Devise views copied to app so you can modify them
- git is initialised
- .gitignore updated to take care of .DS_Store and .env files
- Pages controller updated, with home page set as root in routes.rb

**To do afterwards**
- Configure Action Mailer production url in /config/environments/production.rb on line 4
- Add git remote and push
- Style your alert messages in app/views/shared/_flashes.html.erb
- Asset pipeline... Rails is a bit in flux now so I cannot make a choice or recommendation for you. This template just does the Rails 7 defaults (so no Webpacker). You'll have to implement whatever makes sense for your project. If you're going to stick to vanilla CSS and Javascript all in the 'Application' files then you need to do nothing extra. Maybe a good start for a small app? [This may help.](https://discuss.rubyonrails.org/t/guide-to-rails-7-and-the-asset-pipeline/80851)
