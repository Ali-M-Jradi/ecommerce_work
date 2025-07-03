# 🛒 Cart Page

The CartPage manages the shopping cart functionality, allowing users to review, modify, and proceed with their product selections for checkout.

## 📋 **Overview**

The CartPage provides comprehensive cart management with:
- Cart item display with product details
- Quantity adjustment controls
- Remove/undo item functionality
- Cart summary with totals
- Clear all items option
- Checkout initiation
- Empty cart state handling

## 🏗️ **File Structure**

```
cart_page/
├── cart_page.dart                     # Main cart page widget
├── cart_page_widgets/
│   ├── cart_item_widget.dart         # Individual cart item component
│   ├── cart_summary_widget.dart      # Cart totals and checkout
│   └── empty_cart_widget.dart        # Empty state component
└── README.md                         # This documentation
```

## 🎯 **Key Components**

### **CartPage (cart_page.dart)**
```dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});
}
```

**Features:**
- ✅ Real-time cart state updates
- ✅ Cart item management
- ✅ Total calculations
- ✅ Checkout flow initiation
- ✅ Empty state handling

### **CartItemWidget**
```dart
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
}
```

**Features:**
- ✅ Product image display
- ✅ Brand and product name
- ✅ Size information (if available)
- ✅ Price display (unit and total)
- ✅ Quantity controls (+/- buttons)
- ✅ Remove item button
- ✅ Smart quantity management

### **CartSummaryWidget**
```dart
class CartSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;
  final VoidCallback onCheckout;
}
```

**Features:**
- ✅ Subtotal calculation
- ✅ Shipping cost display
- ✅ Total amount calculation
- ✅ Prominent checkout button
- ✅ Cost breakdown

### **EmptyCartWidget**
```dart
class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});
}
```

**Features:**
- ✅ Friendly empty state message
- ✅ Shopping encouragement
- ✅ Navigation to products
- ✅ Visual cart icon

## 🎨 **Layout Structure**

```
CartPage
├── AppBar
│   ├── Title: "Shopping Cart"
│   ├── Back button
│   └── "Clear All" action (if items exist)
├── Body
│   ├── Cart Items List (if not empty)
│   │   ├── CartItemWidget (for each item)
│   │   └── CartSummaryWidget
│   └── EmptyCartWidget (if empty)
```

## 🛍️ **Cart Item Management**

### **CartItem Model**
```dart
class CartItem {
  final String id;
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String image;
  final String? size;
  final String? category;
  int quantity;
  final String? description;
  
  double get totalPrice => price * quantity;
}
```

### **Quantity Controls**
```dart
Row(
  children: [
    // Decrease button (- or delete if quantity = 1)
    IconButton(
      onPressed: () {
        if (cartItem.quantity > 1) {
          onQuantityChanged(cartItem.quantity - 1);
        } else {
          onRemove(); // Remove item completely
        }
      },
      icon: Icon(
        cartItem.quantity > 1 ? Icons.remove : Icons.delete_outline,
      ),
    ),
    
    // Quantity display
    Text(cartItem.quantity.toString()),
    
    // Increase button
    IconButton(
      onPressed: () => onQuantityChanged(cartItem.quantity + 1),
      icon: Icon(Icons.add),
    ),
  ],
)
```

## 💰 **Cart Calculations**

### **Price Display Logic**
```dart
// Individual item price
Text('\$${cartItem.price.toStringAsFixed(2)}')

// Total for item (if quantity > 1)
if (cartItem.quantity > 1)
  Text('Total: \$${cartItem.totalPrice.toStringAsFixed(2)}')
```

### **Cart Summary Calculations**
```dart
// Subtotal: sum of all item totals
double get subtotal => _items.fold(0.0, 
  (sum, item) => sum + item.totalPrice);

// Shipping: fixed rate or free over threshold
double get shipping => subtotal >= 50.0 ? 0.0 : 5.99;

// Total: subtotal + shipping
double get total => subtotal + shipping;
```

## 📱 **State Management**

### **CartProvider Integration**
```dart
Consumer<CartProvider>(
  builder: (context, cart, child) {
    if (cart.isEmpty) {
      return const EmptyCartWidget();
    }
    
    return Column(
      children: [
        // Cart items
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = cart.items[index];
              return CartItemWidget(
                cartItem: cartItem,
                onQuantityChanged: (newQuantity) {
                  cart.updateItemQuantity(cartItem.id, newQuantity);
                },
                onRemove: () {
                  cart.removeItem(cartItem.id);
                },
              );
            },
          ),
        ),
        
        // Cart summary
        CartSummaryWidget(
          subtotal: cart.subtotal,
          shipping: cart.shipping,
          total: cart.total,
          onCheckout: () => _handleCheckout(context),
        ),
      ],
    );
  },
)
```

### **Cart Actions**
```dart
// Update quantity
cart.updateItemQuantity(String cartItemId, int newQuantity)

// Remove single item
cart.removeItem(String cartItemId)

// Clear entire cart
cart.clearCart()

// Undo last removal (if available)
cart.undoLastRemoval()
```

## 🎛️ **User Interactions**

### **Item Removal with Undo**
```dart
void _removeItem(String itemId) {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final removedItem = cartProvider.getItemById(itemId);
  
  cartProvider.removeItem(itemId);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${removedItem.name} removed from cart'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () => cartProvider.undoLastRemoval(),
      ),
      duration: const Duration(seconds: 4),
    ),
  );
}
```

### **Clear All Confirmation**
```dart
void _showClearCartDialog(BuildContext context, CartProvider cart) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.of(context).pop();
            },
            child: const Text('CLEAR ALL'),
          ),
        ],
      );
    },
  );
}
```

## 🎨 **Design System**

### **Colors**
- Primary: `Colors.deepPurple.shade700`
- Success: `Colors.green.shade600`
- Error: `Colors.red.shade600`
- Background: `Color(0xFFFFFBFF)`
- Cards: `Colors.white`

### **Typography**
- Page title: 20px, FontWeight.bold
- Product name: 14px, FontWeight.bold
- Brand name: 12px, FontWeight.w600
- Price: 16px, FontWeight.bold
- Total: 18px, FontWeight.bold

### **Spacing**
- Page padding: 16px
- Card margin: 12px bottom
- Internal padding: 12px
- Button padding: 12px vertical

## 🔧 **Cart Item Layout**

### **Mobile Layout (Default)**
```dart
Row(
  children: [
    // Product image (80x80)
    Container(width: 80, height: 80),
    
    SizedBox(width: 12),
    
    // Product details (expanded)
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand, name, size
          // Price and quantity controls
        ],
      ),
    ),
    
    // Remove button
    IconButton(icon: Icons.close),
  ],
)
```

### **Quantity Controls Styling**
```dart
Container(
  width: 32,
  height: 32,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(6),
  ),
  child: IconButton(
    padding: EdgeInsets.zero,
    iconSize: 16,
    onPressed: onPressed,
    icon: Icon(icon),
  ),
)
```

## 💳 **Checkout Integration**

### **Checkout Button**
```dart
ElevatedButton(
  onPressed: cart.isEmpty ? null : () => _handleCheckout(),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple.shade600,
    minimumSize: const Size(double.infinity, 50),
  ),
  child: Text(
    'PROCEED TO CHECKOUT',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### **Checkout Flow Initiation**
```dart
void _handleCheckout() {
  // Navigate to checkout page (when implemented)
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CheckoutPage(
        cartItems: cart.items,
        total: cart.total,
      ),
    ),
  );
  
  // For now, show coming soon dialog
  _showCheckoutComingSoon();
}
```

## 🔒 **Error Handling**

### **Empty States**
- Empty cart with encouraging message
- Network error handling
- Invalid item data handling

### **Quantity Validation**
```dart
void updateQuantity(int newQuantity) {
  if (newQuantity < 1) {
    removeItem(); // Auto-remove if quantity becomes 0
    return;
  }
  
  if (newQuantity > maxAllowed) {
    showError('Maximum quantity exceeded');
    return;
  }
  
  // Update quantity
  cartItem.quantity = newQuantity;
}
```

## 🐛 **Troubleshooting**

### **Common Issues**

1. **Cart not updating**
   ```dart
   // Ensure CartProvider is properly wrapped
   ChangeNotifierProvider(
     create: (context) => CartProvider(),
     child: MyApp(),
   )
   ```

2. **Quantity controls not working**
   ```dart
   // Check callback implementation
   onQuantityChanged: (newQuantity) {
     cart.updateItemQuantity(cartItem.id, newQuantity);
   }
   ```

3. **Images not displaying**
   ```dart
   // Add error handling for images
   errorBuilder: (context, error, stackTrace) {
     return Icon(Icons.spa, size: 40);
   }
   ```

## 📊 **Analytics Events**

### **Trackable Actions**
- Cart page viewed
- Item quantity changed
- Item removed from cart
- Cart cleared
- Checkout initiated
- Undo action used

### **Implementation**
```dart
void _trackCartAction(String action, Map<String, dynamic> properties) {
  Analytics.track('cart_$action', {
    'cart_value': cart.total,
    'item_count': cart.itemCount,
    ...properties,
  });
}
```

## 🔮 **Future Enhancements**

- [ ] Save for later functionality
- [ ] Recommended products
- [ ] Bulk quantity updates
- [ ] Cart sharing
- [ ] Promo code application
- [ ] Express checkout options
- [ ] Cart abandonment recovery
- [ ] Inventory warnings
- [ ] Price change notifications
- [ ] Cart persistence across sessions

## 📈 **Performance Considerations**

- **Efficient ListView**: Uses `ListView.builder` for large carts
- **State Management**: Minimal rebuilds with Provider
- **Image Optimization**: Cached images with error handling
- **Memory Management**: Proper disposal of controllers

## 🧪 **Testing Strategy**

### **Unit Tests**
- Cart calculations
- Quantity validations
- State management

### **Widget Tests**
- Cart item rendering
- User interactions
- Empty states

### **Integration Tests**
- Full cart flow
- Checkout navigation
- Cross-page state persistence
