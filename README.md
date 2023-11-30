# Amenitiz's Cash Register

## Overview

This is a Ruby Command Line Interface (CLI) application for the Senior Software Egineer position at Amenitiz. 
The application provides is a simple, e-commerce-like checkout.

### Requirements

- Ruby 3.1.2 or higher
- Bundler gem (for installing dependencies)

### Installation

1. **Clone the Repository:**

    ```bash
    git clone git@github.com:JoseMPena/cash_register.git
    cd cash_register
    ```

2. **Install Dependencies:**

   Ensure you have Bundler installed. Run the following command to install gem dependencies:

    ```bash
    bundle install
    ```

3. **Add Execution Permission to the Executable File:**

   Set executable permissions for the `bin/my_cli_app` file using the following command:

    ```bash
    chmod +x bin/cash_register
    ```

## Usage

### Running the CLI

To execute the CLI, use the `bin/cash_register` executable:

```bash
./bin/cash_register start
```

### Available Commands

- `add <product code>`: Adds a product to the checkout.
  Example: `add GR1`
- `remove <product code>`: Removes a product from the checkout
  Example: `remove SR1`
- `empty cart`: Removes all products from the checkout

- `exit`: Exits the application

### Application Workflow

- Upon starting the application, a welcome message and the current product inventory will be displayed.  
- Add or remove products from the cart using the add and remove commands. 
- Use the empty command to clear the cart. 
- Enter exit to close the application.

### Tests
This application is covered by tests, using RSpec as testing framework and (mostly) Test Driven Development (TDD)

#### Running the test suite
```bash
bundle exec rspec spec
```

### Application Structure
The application consists of two main classes:

#### CLI Class
Provides a CLI interface for users to interact with the cash register.
Displays the welcome guide, current inventory, and cart updates based on user commands.

#### Main Class
Manages product preparation, promotions, and checkout functionality.
Serves as an entry-point, interfaces product handling and emptying the cart.

#### Checkout Class
Holds the required products, applies promotions and performs calculations on the checkout

### Promotions Class
Acts as a base class defining generic methods for promotions, such as checking eligibility 
for certain products or line items within a checkout

#### BuyOneGetOnePromo
Encapsulates the specific behavior of the "Buy One Get One" promotion, 
It determines eligible line items and adjusts their prices accordingly.

#### BuyOneGetOnePromo
Encapsulates the behavior of a bulk discount promotion. Applies a discount of 0.50€ 
when a customer purchases three or more units of a particular product, as specified by the defined rules.

#### BulkPriceDropPromo
Adjusts the price of applicable items by a given fraction, specified by the promotion's defined rules.

#### Product
Abstract the data and behaviour of a product to be used in the checkout.

### LineItem
Represents a specific product item associated with a checkout object.
Tracks essential attributes such as code, original price, quantity, and final price

### Design Decisions and Issues Found
- The application was built on Ruby, using SOLID principles in Object Oriented design.
- Some rounding and precision related issues were found while calculating promotion discounts using floating point numbers.
 Using BigDecimal for the calculation and then converting to float for presentation yielded the best results in some cases.
