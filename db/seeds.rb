  # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all
Order.destroy_all
ItemOrder.destroy_all

#users
john = User.create(name: "John", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password")
jenn = User.create(name: "Jenn", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "lols@example.com", password: "password")
#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
toy_shop = Merchant.create(name: "Wizard's Toy Shop", address: '125 Spinny St.', city: 'Denver', state: 'CO', zip: 80203)
tree_shop = Merchant.create(name: "Wizard's Toy Shop", address: '125 Spinny St.', city: 'Denver', state: 'CO', zip: 80203)
magic_shop = Merchant.create(name: "Wizard's Toy Shop", address: '125 Spinny St.', city: 'Denver', state: 'CO', zip: 80203)
snack_shop = Merchant.create(name: "Wizard's Toy Shop", address: '125 Spinny St.', city: 'Denver', state: 'CO', zip: 80203)

#user
user_0 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "user@example.com", password: "password", role: 0)

user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: dog_shop)

user_2 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "admin@example.com", password: "password", role: 2)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#toy_shop items
plane = toy_shop.items.create(name: "Plane", description: "Yerp", price: 17, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 89)
baklava = toy_shop.items.create(name: "Baklava", description: "Flaky!", price: 78, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 43)

#tree_shop items
maple = tree_shop.items.create(name: "Maple Tree", description: "Tall and Strong", price: 56, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 22)

#magic_shop items
wand = magic_shop.items.create(name: "Wand", description: "Floating time", price: 45, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 33)

#snack_shop items
meat = snack_shop.items.create(name: "Beef Jerky", description: "Nummy", price: 12, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 78)

order_1 = john.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
order_2 = jenn.orders.create(name: "Jenn", address: "234 Loser ln", city: "Denver", state: "Colorado", zip: 78975)

ItemOrder.create(item: pull_toy, order: order_1, quantity: 7, price: 54)
ItemOrder.create(item: tire, order: order_1, quantity: 3, price: 83)
ItemOrder.create(item: plane, order: order_1, quantity: 6, price: 83)
ItemOrder.create(item: baklava, order: order_1, quantity: 89, price: 83)
ItemOrder.create(item: dog_bone, order: order_1, quantity: 65, price: 83)
ItemOrder.create(item: chain, order: order_1, quantity: 1, price: 83)
ItemOrder.create(item: maple, order: order_2, quantity: 1, price: 83)
ItemOrder.create(item: wand, order: order_2, quantity: 1, price: 83)
ItemOrder.create(item: meat, order: order_2, quantity: 1, price: 83)
