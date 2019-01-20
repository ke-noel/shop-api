# shop-api

Shop-api is a Ruby on Rails RESTful API for a basic online marketplace. It uses Json Web Tokens (JWT) for authentication. This project was written for Shopify's 2019 Developer Internship technical challenge.

## Getting Started
### Prerequisites
- Ruby 2.3.3
- Rails 5.2.2
- curl, or some equivalent program (to communicate with the API)

### Installation
It is currently only a local application and is not set up for production.
1. Download the repository.
2. Generate the tables.
`$ rails db:migrate`
3. Populate the products table from the template in config/seeds.rb. The existing template generates 100 book products with a title (using Faker::Book), a price, and an inventory_count.
`$ rails db:seed`
4. Start the server.
`rails server`
5. You're good to go!

### Unit tests
There aren't any unit tests yet, but some will be added in later commits.
## Usage
Curl is used in the following examples, but other similar tools will work too. When deployed locally, the default rails server address is localhost:3000, or just :3000.
### Getting authentication
A token is necessary to make any requests to the API. To get a token, you must first register a user and then log in using these credentials. If the credentials are correct, the API will return a unique web token. Note that the token will time out in 2 hours. To change this timeout, modify app/auth/java_web_token.rb:exp.
#### Registration
You will need to create a user.<br>
`$ curl -H "Content-Type: application/json" -X POST -d '{"name":"<name>","password":"<password>"}' :3000/auth/register`<br>
For those not familiar with curl, -H is the header, -X forces a specified CRUD request type (like GET, POST, PUT, etc.) and -d is the data.<br>
If the registration is successful, the API will return:<br>
`>> { "message":"User created successfully." }`

#### Logging in
`$ curl -H "Content-Type: application/json" -X POST -d '{"name":"<name>","password":"<password>"}'' :3000/auth/login`<br>
If the credentials match those of a user in the API's User table, it will return:<br>
`>> { "access-token": <token>,"message": "Login successful!" }`

#### Making requests
All requests must contain the following:<br>
`$ curl -H "Authorization: <token>"`<br><br>

The API supports the following requests:
- get all products
- get all products that are in stock (inventory_count > 0)
- get all products that are out of stock (inventory_count == 0)
- get a single product using its id number
- purchase a product by its id

##### Get all products
`$ curl -H "Authorization: <token>" :3000/api/v1/products`
##### Get in stock/out of stock products
`$ curl -H "Authorization: <token>" :3000/api/v1/products?in_stock="true"`<br>
The above will return all products with an inventory_count > 0. To return products that are out of stock instead, use in_stock="false" instead.
##### Get a single product
`$ curl -H "Authorization: <token>" :3000/api/v1/products/:id`<br>
The id is the integer that corresponds to the instance's position in the table.<br><br>
`$ curl -H "Authorization: <token>" :3000/api/v1/products/1`<br>
`>> {"message":{"id":1,"title":"A Handful of Dust","price":"20.57","inventory_count":3}`<br>
##### Purchase a product
If the inventory_count of the specified product is non-zero, purchasing a product reduces its inventory_count by 1. Otherwise, the API returns an error message.<br>
`$ curl -H "Authorization: <token>" :3000/api/v1/products/:id/purchase`<br><br>
For example:<br>
`$ curl -H "Authorization: <token>" :3000/api/v1/products/1/purchase`<br>
`>> {"message":"A Handful of Dust has been purchased for $20.57. There are 2 left in stock."}`

## Acknowledgments
The authentication in this API is heavily based on this tutorial: https://www.codementor.io/omedale/simple-approach-to-rails-5-api-authentication-with-json-web-token-cpqbgrdo6.
