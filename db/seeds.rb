# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
plant_shop = Merchant.create(name: "Kelly's Gardens", address: '4456 Flower Ave.', city: 'Gardenia', state: 'NY', zip: 77890)
music_shop = Merchant.create(name: "Chase's Tasty Jams", address: '4435 Les Paul Ave', city: 'Telluride', state: 'CO', zip: 90879)
fly_shop = Merchant.create(name: "Franks's Fly's & Ties", address: '6678 Fly St.', city: 'Durango', state: 'CO', zip: 80010)
bee_shop = Merchant.create(name: "Alex's Bee Gardens", address: '6678 Bzzz Rd.', city: 'Paris', state: 'TX', zip: 60700)
ski_shop = Merchant.create(name: "Travis's Sleds & Shreds", address: '5467 Pow St.', city: 'Jackson', state: 'WY', zip: 34567)

ski_shop.discounts.create!(name: "winter special", number_items: 5, percent: 5)
ski_shop.discounts.create!(name: "big sale", number_items: 10, percent: 15)

plant_shop.discounts.create!(name: "mother's day special", number_items: 3, percent: 10
#plant_shop items
azaleas = plant_shop.items.create(name: "Azaleas", description: "Gorgeous plants, dogs love them.", price: 15, image: "https://www.directgardening.com/1718-thickbox_default/pink-azalea.jpg", inventory: 1)
palm = plant_shop.items.create(name: "Palm Tree", description: "I like coconuts!", price: 50, image: "https://upload.wikimedia.org/wikipedia/commons/7/7a/1859-Martinique.web.jpg", inventory: 4)
roses = plant_shop.items.create(name: "Roses", description: "Smells like teen spirit", price: 30, image: "https://richmedia.channeladvisor.com/ImageDelivery/imageService?profileId=12026540&id=1127763&recipeId=728", inventory: 2)
sod = plant_shop.items.create(name: "Sod", description: "Don't sod, ya cry baby", price: 20, image: "https://www.centralsodil.com/media/catalog/product/cache/5/image/650x/040ec09b1e35df139433887a97daa66f/s/o/sod_1.jpg", inventory: 6)
soil = plant_shop.items.create(name: "Soil", description: "Manure....", price: 8, image: "https://images.homedepot-static.com/productImages/8d51618a-abef-4199-9eb8-c8030f7fd37c/svn/miracle-gro-garden-soil-75030430-64_1000.jpg", inventory: 11)

#music_shop items
guitar = music_shop.items.create(name: "Languedoc", description: "Trey shred one, so can you!", price: 10000, image: "https://s-media-cache-ak0.pinimg.com/236x/29/ae/ff/29aeffadf8ab32379d37b8605e79b1fe.jpg", inventory: 1)
drums = music_shop.items.create(name: "Drums", description: "Bang these bad boys all day", price: 5000, image: "https://i.pinimg.com/originals/fe/da/c2/fedac2f25210eba4fec16e52196ff9d8.jpg", inventory: 12)
bass = music_shop.items.create(name: "Bass", description: "Okayist Bassist", price: 4500, image: "https://www.premierguitar.com/ext/resources/images/content/2015-02/Rig-Rundowns/Umphreys-McGee/Stasik-Bass-WEB.jpg", inventory: 3)
keys = music_shop.items.create(name: "Keys", description: "Electrify the crowd", price: 4000, image: "https://pagemcconnell.com/wp-content/uploads/2012/02/DSC_0029-e1359740978493-192x192.jpg", inventory: 5)

#fly_shop items
reel = fly_shop.items.create(name: "Fly Reel", description: "Abel Super 5wt", price: 600, image: "https://www.rossreels.com/rr-news/abel-reels/wp-content/uploads/sites/7/2017/01/ss-wt-1.png", inventory: 6)
fly_line = fly_shop.items.create(name: "Fly Line", description: "Fish can't see or break it!", price: 60, image: "https://cdn11.bigcommerce.com/s-h8h1haj1/images/stencil/1280x1280/products/425/1800/20190117_191540__27881.1547775957.jpg?c=2&imbypass=on", inventory: 3)

#bee_shop items
colony = bee_shop.items.create(name: "Colony", description: "Buzz Buzz", price: 155, image: "https://cdn.shopify.com/s/files/1/0123/6556/1915/products/Bees_at_bee_friends_fram_2.jpeg?v=1567775402", inventory: 5)
mask = bee_shop.items.create(name: "Mask", description: "Face protection", price: 48, image: "https://www.maykool.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/y/e/yellow-bee-cute-halloween-costume-mask-071478.jpg", inventory: 3)
gloves = bee_shop.items.create(name: "Gloves", description: "No stings", price: 35, image: "https://www.humblebee.us/cdn11.bigcommerce.com/s-6jze3ivpew/images/stencil/1536x2048/products/120/385/112_1__24434.1542757067.jpg", inventory: 2)
suit = bee_shop.items.create(name: "Suit", description: "Look like an astronaut, no bee stings!", price: 120, image: "https://smhttp-ssl-60515.nexcesscdn.net/media/catalog/product/cache/1/thumbnail/600x600/9df78eab33525d08d6e5fb8d27136e95/p/r/professionalbeesuit.jpg", inventory: 12)
hive = bee_shop.items.create(name: "Hive", description: "mmmmmm.... Honey", price: 80, image: "https://www.honeyflow.com/media/images/content/thumb/a7rii_FH2_WRC_HERO_20180413_35-Edit_blue_sky_replace_72dpi-text2071.jpg", inventory: 2)

#ski_shop items
skis = ski_shop.items.create(name: "Skis", description: "Faction Cadide 2.0", price: 500, image: "https://images.evo.com/imgp/700/139334/589343/faction-candide-2-0-skis-2019-.jpg", inventory: 2)
snowboard = ski_shop.items.create(name: "Snowboard", description: "Never Summer", price: 700, image: "https://content.backcountry.com/images/items/900/NVS/NVS008S/ONECOL.jpg", inventory: 8)
gloves = ski_shop.items.create(name: "Gloves", description: "Warmer than the sun", price: 60, image: "https://www.rei.com/media/0376a43a-2e9f-4fee-b7e3-471a46e68d08?size=512x682", inventory:7 )
helmet = ski_shop.items.create(name: "Helmet", description: "Gotta protect that noggin!", price: 130 , image: "https://www.rei.com/media/9cd10ca0-81b6-49d0-b5b2-f5bf0859f628?size=784x588", inventory: 6 )
hand_warmers = ski_shop.items.create(name: "Hand Warmers", description: "Hotter than hockey sticks!", price: 1, image: "https://images-na.ssl-images-amazon.com/images/I/91RmQzKenOL._SL1500_.jpg", inventory: 12)
boots = ski_shop.items.create(name: "Dalbello Boots", description: "These babies will protect your feet", price: 350, image: "https://images.evo.com/imgp/700/158018/695132/clone.jpg", inventory: 25)
beanies = ski_shop.items.create(name: "Beanies", description: "Nice warm wool hat", price: 35, image: "https://images-na.ssl-images-amazon.com/images/I/614eeyR-UWL._AC_UX385_.jpg", inventory: 10)

# Users
merchant_user1 = ski_shop.users.create!(name: "Johnny",
  street_address: "123 Jonny Way",
  city: "Johnsonville",
  state: 'TN',
  zip_code: 12345,
  email: "merchant@example.com",
  password: "merchant",
  role: 1
)

merchant_user2 = bee_shop.users.create!(name: "Jeremiah",
  street_address: "7777 Rastafari Way",
  city: "Jamaica",
  state: 'FL',
  zip_code: 46766,
  email: "merchant2@example.com",
  password: "merchant2",
  role: 1
)

admin_user = User.create!(name: "Johnny",
  street_address: "123 Jonny Way",
  city: "Johnsonville",
  state: 'TN',
  zip_code: 12345,
  email: "admin@example.com",
  password: "admin",
  role: 2
)

default_user = User.create!(name: "Johnny",
  street_address: "123 Jonny Way",
  city: "Johnsonville",
  state: 'TN',
  zip_code: 12345,
  email: "default@example.com",
  password: "default",
  role: 0
)
