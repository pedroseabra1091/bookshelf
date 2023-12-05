# Bookshelf

Bookshelf is a streamlined web app for sharing books, purpose-built as the go-to material for Deemaze Rails training.

### Features
— Reserve and return book;

– Reservation history;

– Books other users are reading;

### Setup guide

There are a couple of system dependencies that have to be installed before moving to the application dependencies:
- `ruby` – Either [asdf](https://asdf-vm.com/) or [RVM](https://rvm.io/) are fine choices;
– `node` – My recommendation goes to [asdf](https://asdf-vm.com/)
– `redis`

Once all package managers are installed, execute the following to set all the system dependencies versions:
```
asdf install
```
Next, execute the application setup script which will install all application dependencies are create the database:
```
bin/setup
```
Now with everything set, the development server can be executed and visited at `localhost:3000`:
```
bin/dev
```
