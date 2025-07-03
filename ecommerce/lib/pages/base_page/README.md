# 🏠 Base Page

The BasePage is the main container and navigation hub for the entire DERMOCOSMETIQUE ecommerce application.

## 📋 **Overview**

BasePage serves as the root scaffold that provides:
- Global navigation structure
- Bottom navigation bar
- App bar with cart functionality
- Side drawer menu
- Floating action buttons

## 🏗️ **File Structure**

```
base_page/
├── base_page.dart                     # Main base page widget
├── base_page_widgets/
│   ├── app_bar.dart                  # Custom app bar with navigation
│   ├── drawer_widget.dart            # Side navigation drawer
│   └── floating_action_buttons_widget.dart  # FAB for loyalty & contact
└── README.md                         # This documentation
```

## 🎯 **Key Components**

### **BasePage (base_page.dart)**
```dart
class BasePage extends StatefulWidget {
  final String title;
  final int? initialIndex;
}
```

**Features:**
- ✅ Bottom navigation with 4 tabs (Search, Cart, Products, Profile)
- ✅ Dynamic floating action button visibility
- ✅ Global navigation state management
- ✅ Responsive layout

### **AppBarWidget (app_bar.dart)**
```dart
class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onNavigationTap;
}
```

**Features:**
- ✅ Brand logo and title
- ✅ Navigation destinations
- ✅ Cart badge with item count
- ✅ Notifications icon
- ✅ Responsive design

### **DrawerWidget (drawer_widget.dart)**
```dart
class DrawerWidget extends StatelessWidget {
  final Function(int) onNavigationTap;
}
```

**Features:**
- ✅ User profile section
- ✅ Navigation menu items
- ✅ Category quick access
- ✅ Settings and help sections

### **FloatingActionButtonsWidget**
```dart
class FloatingActionButtonsWidget extends StatelessWidget {
  final String? heroTagPrefix;
  final VoidCallback? onLoyaltyPressed;
  final VoidCallback? onContactPressed;
}
```

**Features:**
- ✅ Loyalty program access
- ✅ Contact us functionality
- ✅ Unique hero tags to prevent conflicts
- ✅ Animated visibility

## 🎨 **Design System**

### **Colors**
- Primary: `Colors.deepPurpleAccent.shade700` (#6200EA)
- Background: `Colors.white`
- Text: `Color(0xFF1B1B1B)`

### **Typography**
- App Title: 18px, Medium weight
- Subtitle: 14px, Light weight
- Navigation: 12px, Regular weight

## 🚀 **Navigation Flow**

```
BasePage Navigation:
├── Index 0: Search → ProductsPage (with search focus)
├── Index 1: Cart → CartPage
├── Index 2: Products → ProductsPage (all products)
└── Index 3: Profile → Coming Soon Dialog
```

## 📱 **State Management**

### **Navigation State**
```dart
int _selectedIndex = 0;
bool _showFloatingButtons = true;
```

### **Methods**
- `_handleBottomNavigation(int index)`: Handles bottom nav taps
- `_handleDrawerNavigation(int index)`: Handles drawer menu taps
- `_showComingSoonDialog(String feature)`: Shows feature placeholder

## 🔧 **Key Features**

### **Bottom Navigation**
- 4 destinations with icons and labels
- Real-time cart badge updates
- Smooth animations
- Active state indicators

### **Cart Integration**
```dart
Consumer<CartProvider>(
  builder: (context, cart, child) {
    return Badge(
      label: Text(cart.itemCount.toString()),
      isLabelVisible: cart.itemCount > 0,
      child: Icon(Icons.shopping_cart),
    );
  },
)
```

### **Floating Action Buttons**
- Conditional visibility based on scroll position
- Loyalty program and contact us actions
- Animated slide transitions

## 🎛️ **Customization**

### **Adding New Navigation Items**
```dart
// Add to NavigationBar destinations
NavigationDestination(
  icon: Icon(Icons.new_feature),
  label: 'New Feature',
),

// Add handling in _handleBottomNavigation
case 4: // New Feature
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => NewFeaturePage(),
  ));
  break;
```

### **Modifying App Bar**
- Update `AppBarWidget` for different layouts
- Customize colors in the design system section
- Add new action buttons to the actions array

## 🐛 **Troubleshooting**

### **Common Issues**
1. **Hero tag conflicts**: Ensure unique `heroTagPrefix` for FABs
2. **Navigation not working**: Check route definitions
3. **Cart badge not updating**: Verify CartProvider integration

### **Debug Tips**
- Use Flutter Inspector for widget tree analysis
- Check console for navigation errors
- Verify Provider context availability

## 📈 **Performance**

- **Lazy loading**: Pages created only when navigated to
- **State preservation**: Navigation state maintained across rebuilds
- **Efficient rebuilds**: Only cart badge updates on cart changes

## 🔮 **Future Enhancements**

- [ ] User profile integration
- [ ] Notification badge functionality
- [ ] Deep linking support
- [ ] Tab state persistence
- [ ] Offline mode indicator
