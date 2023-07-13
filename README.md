# Dewald's Rails templates

Use these [Rails Templates](http://guides.rubyonrails.org/rails_application_templates.html) to generate new Rails 7 apps.

## Minimal with authentication

A minimum Rails app with Devise for user authentication.
- Deployment on [Heroku](https://www.heroku.com/)
- PostgreSQL database in Development and Production
- [Simple form (without Bootstrap)](https://github.com/heartcombo/simple_form)
- Font Awesome SASS
- [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails)

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

**To do afterwards**
- Configure Action Mailer production url in /config/environments/production.rb on line 4
- Add git remote and push
- Style your alert messages in app/views/shared/_flashes.html.erb
- Asset pipeline... Rails is a bit in flux now so I cannot make a choice or recommendation for you. This template just does the Rails 7 defaults (so no Webpacker). You'll have to implement whatever makes sense for your project. If you're going to stick to vanilla CSS and Javascript all in the 'Application' files then you need to do nothing extra. Maybe a good start for a small app? [This may help.](https://discuss.rubyonrails.org/t/guide-to-rails-7-and-the-asset-pipeline/80851)

## Webpack with authentication

Same as _Mininal with authentication_ but adds Webpack to handle bundling.
This is not ideal in 2023, but for quick & dirty it works. **I advise you to not use it.**

```bash
rails new \
  -d postgresql \
  -j webpack \
  -m https://raw.githubusercontent.com/dewaldreynecke/rails-templates/main/auth.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
