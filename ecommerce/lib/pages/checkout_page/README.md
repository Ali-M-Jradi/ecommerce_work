# Checkout Page

The checkout page provides a complete multi-step checkout flow for the ecommerce application.

## Overview
The checkout page is a stateful widget that manages the entire checkout process through a stepper interface. It handles address collection, payment method selection, order review, and order confirmation.

## Features

### Multi-Step Checkout Flow
- **Step 1 - Address**: Collect shipping and billing addresses
- **Step 2 - Payment**: Select payment method and enter payment details
- **Step 3 - Review**: Review order details before confirmation
- **Step 4 - Confirmation**: Display order confirmation and receipt

### State Management
- Manages current step state
- Stores user input across steps (addresses, payment method, order notes)
- Integrates with CartProvider for cart data
- Generates Order objects for completed purchases

### Navigation
- Stepper-based navigation with visual step indicators
- Back/Next button navigation
- Progress tracking with step completion indicators

## Components

### CheckoutPage (`checkout_page.dart`)
Main checkout page that orchestrates the checkout flow:
- Manages checkout steps and navigation
- Handles data persistence across steps
- Provides step validation and progression
- Generates final order objects

### Step Widgets
Located in `checkout_page_widgets/`:

#### AddressStepWidget
- Collects shipping and billing addresses
- Supports "same as shipping" option for billing
- Form validation for address fields
- Address selection and editing

#### PaymentStepWidget
- Payment method selection (Credit Card, PayPal, etc.)
- Payment form with validation
- Secure payment information collection
- Payment method icons and branding

#### ReviewStepWidget
- Order summary with item details
- Address and payment method confirmation
- Order notes input
- Final pricing breakdown with taxes and shipping

#### ConfirmationStepWidget
- Order confirmation display
- Order number generation
- Receipt-style order summary
- Navigation options (continue shopping, view order)

## Data Models

### Address
Represents shipping/billing addresses with fields:
- name, street, city, state, zipCode, country
- phone, email for contact information
- isDefault flag for primary address

### PaymentMethod
Represents payment options:
- type (credit card, paypal, etc.)
- cardNumber, expiryDate, cvv (for cards)
- cardholderName, billingAddress
- isDefault flag

### Order
Represents completed orders:
- orderNumber, orderDate, orderStatus
- items (from cart), totalAmount
- shippingAddress, billingAddress
- paymentMethod, orderNotes

## Usage

### Navigation to Checkout
Users can navigate to checkout from:
1. Cart page "Checkout" button
2. Product page "Buy Now" actions
3. Quick checkout flows

### Step Progression
1. User fills out address information
2. User selects and configures payment method
3. User reviews order details and confirms
4. System processes order and shows confirmation

### Data Flow
1. Cart data is accessed via CartProvider
2. User input is collected and validated at each step
3. Order object is created with all collected data
4. Order is processed and confirmation is displayed

## Integration

### CartProvider Integration
- Accesses cart items and totals
- Calculates shipping and taxes
- Manages cart state during checkout

### Navigation Integration
- Integrated with app routing system
- Handles back navigation appropriately
- Manages checkout completion flow

## Error Handling
- Form validation at each step
- Network error handling for order processing
- User feedback for validation errors
- Graceful handling of incomplete data

## Styling
- Consistent with app theme and branding
- Responsive design for different screen sizes
- Clear visual hierarchy and step indicators
- Accessible form design with proper labels

## Future Enhancements
- Guest checkout option
- Multiple payment methods
- Shipping options and calculations
- Order tracking integration
- Saved addresses and payment methods
- Promotional codes and discounts
