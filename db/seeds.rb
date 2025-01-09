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
item4 = Item.create(name: 'Headphones', description: 'Noise-cancelling over-ear headphones', price: 199.99)
item5 = Item.create(name: 'Smartwatch', description: 'A smartwatch with fitness tracking', price: 249.99)
item6 = Item.create(name: 'Tablet', description: 'A portable tablet for work and play', price: 299.99)
item7 = Item.create(name: 'Wireless Mouse', description: 'A smooth wireless mouse', price: 29.99)
item8 = Item.create(name: 'Keyboard', description: 'A mechanical keyboard with RGB lighting', price: 89.99)
item9 = Item.create(name: 'Gaming Chair', description: 'Comfortable gaming chair with adjustable armrests', price: 199.99)
item10 = Item.create(name: 'Bluetooth Speaker', description: 'Portable speaker with excellent sound', price: 79.99)
item11 = Item.create(name: 'Camera', description: 'A DSLR camera for professional photos', price: 799.99)
item12 = Item.create(name: 'Projector', description: 'A compact projector for home entertainment', price: 350.99)
item13 = Item.create(name: 'External Hard Drive', description: '1TB external hard drive for storage', price: 59.99)
item14 = Item.create(name: 'Smart TV', description: 'A 4K Smart TV with streaming apps', price: 599.99)
item15 = Item.create(name: 'Laptop Stand', description: 'Ergonomic laptop stand for better posture', price: 39.99)
item16 = Item.create(name: 'Electric Kettle', description: 'Fast boiling electric kettle', price: 29.99)
item17 = Item.create(name: 'Microwave', description: 'A compact microwave oven for quick meals', price: 89.99)
item18 = Item.create(name: 'Coffee Maker', description: 'A coffee maker with built-in grinder', price: 119.99)
item19 = Item.create(name: 'Smart Light Bulb', description: 'Wi-Fi controlled smart light bulb', price: 19.99)
item20 = Item.create(name: 'Electric Toothbrush', description: 'A high-performance electric toothbrush', price: 49.99)

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
