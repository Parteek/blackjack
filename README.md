# Blackjack Game

**Blackjack** game is simple and interesting card game. For demo please visit [game](https://blackjack-pars.herokuapp.com)

## Installation

**Dependencies**

*Postgres(For ubuntu)*

- `sudo apt-get install postgresql-9.3 libpq-dev`
- `sudo -u postgres createuser 'username' -s`
- `sudo -u postgres psql`
- `\password 'username'`
- `now type your password 'password'`

**Install gems**
```
bundle install
```

**Configure the database**
- `cp config/database.yml.example config/database.yml` (Change the db config in created file)
- `rake db:create`
- `rake db:migrate`

## Test the app
You can check that your app runs properly by entering the command
```
$ rails s
```
To see your application in action, open a browser window and navigate to [http://localhost:3000/](http://localhost:3000). You should see the default rails application page.
