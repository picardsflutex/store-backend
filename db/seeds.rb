puts "Seeding Users..."
user = User.create(
  first_name: 'Andrii', 
  last_name: 'Chernov', 
  email: 'admin@test.com', 
  password: 'admin123',
  role: 'admin'
)

puts "Seeding Items..."
item1 = Item.create(name: 'Laptop', description: 'A powerful laptop', price: 999.99)
item2 = Item.create(name: 'Phone', description: 'A smartphone with great features', price: 499.99)
item3 = Item.create(name: 'TV', description: 'A TV with good screen', price: 399.99)

puts "Seeding Orders..."
order_amount = item1.price + item2.price * 2 
order = Order.create(
  user: user, 
  amount: order_amount
)

puts "Seeding Order Descriptions..."
OrderDescription.create(order: order, item: item1, price: item1.price, quantity: 1)
OrderDescription.create(order: order, item: item2, price: item2.price, quantity: 2)

puts "Seeding completed!"
