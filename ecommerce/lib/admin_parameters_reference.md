# Admin Parameters Reference

Below are recommended parameters for your ecommerce app. These keys should be used by the admin to control app behavior and display. Each parameter includes a description and example value.

| Key                    | Description                                      | Example Value         |
|------------------------|--------------------------------------------------|----------------------|
| shipping_tax           | Shipping tax percentage                          | 5                    |
| free_shipping_threshold| Minimum order value for free shipping            | 50                   |
| support_email          | Customer support email address                   | help@company.com     |
| support_phone          | Customer support phone number                    | +1234567890          |
| maintenance_mode       | Show maintenance banner (true/false)             | true                 |
| app_version_message    | Message to show users about app updates          | Update available!    |
| default_currency       | Default currency code                            | USD                  |
| welcome_message        | Welcome message for users                        | Welcome to our shop! |
| discount_rate          | Global discount rate (%)                         | 10                   |
| max_cart_items         | Maximum items allowed in cart                    | 20                   |

**How to use:**
- Admins should use these keys when adding or editing parameters.
- The app will use these keys to display or control features in the correct places.
- Custom keys can be added for advanced use, but only the above are guaranteed to be used by the app UI.
