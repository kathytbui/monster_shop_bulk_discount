## About

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Sessions were used in order to aid cart creation. Sessions and bycrypt were used to aid user authentication. Each user role will have access to some or all CRUD functionality for application models.

[Heroku Link](https://pacific-mesa-85748.herokuapp.com/)

## Setup
```
git clone https://github.com/Chulstro/monster_shop_2005
cd monster_shop_2005
bundle install
rails db:create
rails db:migrate
```
Run `$ rails s` to start the server

## Testing
Run `bundle exec rspec` to run the automated test suite

## Schema
![Application Scheme](/app/assets/images/schema.jpg)

## Website
![Application Reviews](/app/assets/images/Reviews.jpg)
![Application Cart](/app/assets/images/cart.jpg)
![Application Items Index](/app/assets/images/items_index.jpg)
![Application User Index](/app/assets/images/user_index.jpg)

## Code Snippets
**CRUD functionality**

CREATE
```
  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end
```

READ
```
  def index
    @merchants = Merchant.all
  end
```

UPDATE
```
  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
  end
```

DESTROY
```
  def destroy
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end
```

**Controllers**
BASE CONTROLLER
We implemented a BaseController for both the Admin and the Merchant to handle the restrictions on views only authorized users were allowed to see.
```
  class Admin::BaseController < ApplicationController

    before_action :require_admin

    private
    def require_admin
      if user.nil? || !user.admin?
        render file: "/public/404"
      end
    end
  end
```

SESSIONS CONTROLLER
We created a private method that redirected users depending on their authorizations.
```
  private
  def user_redirect(user)
    if user.admin?
      redirect_to "/admin/dashboard"
    elsif user.merchant?
      redirect_to "/merchant/dashboard"
    else
      redirect_to "/profile"
    end
  end
```

**MODELS**
We were able to create models for all of our active record resources.

Model defaults for records without specific data
```
class ItemOrder <ApplicationRecord
  after_initialize :default_status, :set_merchant

  private
  def default_status
    self.status = 0 if status.nil?
  end

  def set_merchant
    if !item.nil?
      item = Item.find(self.item_id)
      self.item_merchant_id = item.merchant_id
    end
  end
```

Validations
```
validates_presence_of :name,
                      :description,
                      :price,
                      :image,
                      :inventory
validates_inclusion_of :active?, :in => [true, false]
validates_numericality_of :price, greater_than: 0
```

MODEL METHODS
```
  def self.order_by_pop
    Item.joins(:item_orders).select('SUM(item_orders.quantity) AS sum_quantity, items.name').group('items.id').order('SUM(item_orders.quantity) desc').limit(5)
  end
```

**Views**

FORM VIEWS
```
Edit Item

  <%= form_tag "/admin/merchants/#{@item.merchant.id}/items/#{@item.id}", method: :patch do %>
    <%= label_tag :name %>
    <%= text_field_tag :name, @item.name %>
    ...
    <%= submit_tag %>
  <% end %>
```

## Contributors
Kathy Bui: [GitHub](https://github.com/Kathybui732)

Chandler Hulstrom: [Github](https://https://github.com/Chulstro)

Phillip Strom: [Github](https://github.com/Strompy/)

[Heroku Link](https://pacific-mesa-85748.herokuapp.com/)

## Wishlist
If we had more time, here are a few things we would have liked to employ:
  1.  We would have liked to have created a PasswordsController and remove that responsibility from the UsersController. This would have allowed for more restful routes and gave our controllers more single responsibilities.
  1.  We would would have liked to use more resources in the routes to clean up the code. This would have allowed us to clean up our code everywhere we referenced a path as well.
  1.  Applying partials to clean up our views would have been another thing we employed had we had more time. We recognized that there were very many commonalities between the edit and create views that could have used partials. The merchant's orders index and the admin's order index would have been another place a partial would have been useful.
