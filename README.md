# shop-api

This is a RESTful API for a very basic online marketplace. It supports fetching items one at a time, all at once or by whether or not they are in stock. Users can also "purchase" items. The API uses JWT for authentication.

## System Requirements
- Ruby 2.3.3
- Rails 5.2.2

## Setup
1. Download this repository.
2. Generate your tables.
`
$ rails db:migrate
`
3. Populate your products table. It uses config/seeds.rb to generate the Product instances. It's currently set up as a bookstore and generates 100 book titles (using Faker), prices and inventory_counts.
`
$ rails db:seed
`
4. Start your server session.
`
$ rails server
`
5. You're good to go!

## Using the API
For the following, I used curl, but similar services would work too. By default, the rails server runs on localhost:3000.

### Register
To access the database, you will need to create a user.<br>
`
$ curl --header "Content-Type: application/json" --request POST --data '{"name":"<name>","password":"<password>"}' :3000/auth/register
`
`
{"message":"User created successfully."}
`

### Login
When you log in with your credentials, the API will generate and return a token. You'll need to pass that token with every request. Note: tokens expire after 2 hours. To change this, modify app/auth/json_web_token.rb:exp. <br>
`
$ curl --header "Content-Type: application/json" --request POST --data '{"name":"<name>","password":"<password>"}' :3000/auth/login
`
`
{"access_token":"<token>","message":"Login successful!"}
`

### Accessing the data
The following fetches all items and returns all of their attributes: product_id, title, price, inventory_count, created_at, updated_at. <br>
`
$ curl -H "Authorization: <token>" :3000/api/v1/products
`

To return all items that are in stock (inventory_count > 0), enter the following instead: <br>
`
$ curl -H "Authorization: <token>" :3000/api/v1/products?in_stock="true"
`
To return all items that are out of stock, change the argument to "false".

To return a single item by its product_id: <br>
`
$ curl -H "Authorization: <token>" :3000/api/v1/products/:id
`
`
$ curl -H "Authorization: <token>" :3000/api/v1/products/1
{"message":{"id":1,"title":"Dance Dance Dance","price":5.94,"inventory_count":13,"created_at":"2019-01-20T17:25:59.873Z","updated_at":"2019-01-20T17:25:59.873Z"}}
`

Purchasing an item lowers the inventory_count by 1 and will return an error message if the item is out of stock. To purchase an item: <br>
`
$ curl -H "Authorization: <token>" :3000/api/v1/products/:id/purchase
`
`
$ curl -H "Authorization: <token>" :3000/api/v1/products/1/purchase
{"message":"Dance Dance Dance purchased for $5.94. There are 12 left in stock."}
`

## Resources
The authentication part of this API is heavily based on the following tutorial: https://www.codementor.io/omedale/simple-approach-to-rails-5-api-authentication-with-json-web-token-cpqbgrdo6.