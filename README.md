# Dewald's Rails templates

Use these [Rails Templates](http://guides.rubyonrails.org/rails_application_templates.html) to generate new Rails 7 apps.

## With authentication

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
