# Tests for the API of the exercise 09 app.
# {{base_url}} is the address of the API, for example http://localhost:8080/api.

# The API is up.
GET {{base_url}}/ping
HTTP 200
[Asserts]
jsonpath "$" == "pong!"

# It lists the three books the app starts with.
GET {{base_url}}/books
HTTP 200
[Asserts]
jsonpath "$.status" == "success"
jsonpath "$.books" count >= 3

# Add a book.
POST {{base_url}}/books
{"title": "1Q84", "author": "Haruki Murakami", "read": true}
HTTP 200
[Asserts]
jsonpath "$.message" == "Book added!"

# The new book is listed. Keep its id for the next requests.
GET {{base_url}}/books
HTTP 200
[Captures]
book_id: jsonpath "$.books[?(@.title == '1Q84')].id"
[Asserts]
jsonpath "$.books[?(@.title == '1Q84')].author" == "Haruki Murakami"

# Mark it as not read. The app replaces the book, so it gets a new id.
PUT {{base_url}}/books/{{book_id}}
{"title": "1Q84", "author": "Haruki Murakami", "read": false}
HTTP 200
[Asserts]
jsonpath "$.message" == "Book updated!"

GET {{base_url}}/books
HTTP 200
[Captures]
book_id: jsonpath "$.books[?(@.title == '1Q84')].id"
[Asserts]
# A single match: with two (the old and the new book) this would be a list.
jsonpath "$.books[?(@.title == '1Q84')].title" == "1Q84"
jsonpath "$.books[?(@.title == '1Q84')].read" == false

# Delete it.
DELETE {{base_url}}/books/{{book_id}}
HTTP 200
[Asserts]
jsonpath "$.message" == "Book removed!"

GET {{base_url}}/books
HTTP 200
[Asserts]
jsonpath "$.books[?(@.title == '1Q84')]" not exists
