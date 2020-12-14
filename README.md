# README
Coding exercise for Freska

* Ruby version tested 2.6.0

* Run:
  ```
  git clone git@github.com:bagdenia/fixer_proxy.git
  cd fixer_proxy/
  bundle
  ```
* Add valid access key to .env

* Run with Docker:
  Execute in terminal in application folder:
  * docker-compose build
  * docker-compose up

OR

* Database initialization:
  ```
  rails db:create
  rails db:migrate
  ```
* Run: rails s

* Check for instance: http://localhost:3000/api/v1/rates/2020-12-12?base=EUR&other=USD
