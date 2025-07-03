# 🏠 Home Page

The HomePage is the landing screen that welcomes users and showcases featured products for the DERMOCOSMETIQUE ecommerce app.

## 📋 **Overview**

The HomePage provides an engaging entry point with:
- Featured products carousel
- Category navigation
- Quick access to product catalog
- Brand presentation

## 🏗️ **File Structure**

```
home_page/
├── home_page.dart                     # Main home page widget
├── home_page_widgets/
│   ├── featured_products_carousel.dart  # Featured products section
│   ├── footer_widget.dart            # App footer component
│   └── hero_banner_widget.dart       # Welcome banner section
└── README.md                         # This documentation
```

## 🎯 **Key Components**

### **HomePage (home_page.dart)**
```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});
}
```

**Features:**
- ✅ Scroll-based floating button visibility
- ✅ Custom scroll view layout
- ✅ Responsive design
- ✅ Smooth animations

### **FeaturedProductsCarousel**
```dart
class FeaturedProductsCarousel extends StatefulWidget {
  const FeaturedProductsCarousel({super.key});
}
```

**Features:**
- ✅ Horizontal scrolling product cards
- ✅ "View All" navigation to products page
- ✅ Product detail dialogs
- ✅ Add to cart functionality
- ✅ Responsive grid layout

### **HeroBannerWidget**
```dart
class HeroBannerWidget extends StatelessWidget {
  const HeroBannerWidget({super.key});
}
```

**Features:**
- ✅ Welcome message
- ✅ Brand presentation
- ✅ Category quick access
- ✅ Search encouragement

### **FooterWidget**
```dart
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});
}
```

**Features:**
- ✅ Contact information
- ✅ Social media links
- ✅ Newsletter signup
- ✅ Legal information

## 🎨 **Design System**

### **Layout Structure**
```
HomePage
├── CustomScrollView
│   ├── SliverAppBar (collapsed)
│   ├── SliverToBoxAdapter
│   │   ├── HeroBannerWidget
│   │   ├── FeaturedProductsCarousel
│   │   └── FooterWidget
│   └── SliverFillRemaining (if needed)
```

### **Colors**
- Primary: `Colors.deepPurple.shade700`
- Secondary: `Colors.deepPurpleAccent.shade700`
- Background: `Color(0xFFFFFBFF)`
- Cards: `Colors.white`

### **Spacing**
- Section padding: `16.0px`
- Card margins: `8.0px`
- Content spacing: `12.0px`

## 🛍️ **Featured Products**

### **Product Card Layout**
```dart
Container(
  width: 200,
  child: Column(
    children: [
      // Product image (150x150)
      // Brand name (12px)
      // Product name (14px, bold)
      // Price (16px, bold)
      // Rating (with stars)
    ],
  ),
)
```

### **Product Data**
```dart
final List<Map<String, dynamic>> featuredProducts = [
  {
    'brand': 'Avène',
    'name': 'Thermal Spring Water Face Mist',
    'price': '12.99',
    'rating': '4.5',
    'image': 'assets/images/product.jpg',
    'category': 'face_care',
  },
  // ... more products
];
```

## 🚀 **Navigation & Interactions**

### **Navigation Routes**
```dart
// View All Products
Navigator.push(context, MaterialPageRoute(
  builder: (context) => ProductsPage(
    categoryTitle: 'Featured Products',
  ),
));

// Product Details
showDialog(context, builder: (context) => 
  ProductDetailsDialogWidget(product: product)
);
```

### **Scroll Behavior**
```dart
// Floating button visibility based on scroll
void _onScroll() {
  final bool atBottom = _scrollController.position.pixels >= 
    _scrollController.position.maxScrollExtent - 200;
  
  final bool shouldShow = !atBottom && 
    _scrollController.position.pixels > 100;
    
  // Update visibility state
}
```

## 📱 **State Management**

### **Scroll State**
```dart
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _lastVisibilityState = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
}
```

### **Cart Integration**
- Uses global `CartProvider` for add to cart functionality
- Real-time cart badge updates
- Snackbar notifications for cart actions

## 🎛️ **Customization**

### **Adding New Sections**
```dart
// Add to CustomScrollView slivers
SliverToBoxAdapter(
  child: NewSectionWidget(),
),
```

### **Modifying Featured Products**
```dart
// Update in featured_products_carousel.dart
final List<Map<String, dynamic>> featuredProducts = [
  // Add new products here
];
```

### **Customizing Hero Banner**
```dart
// Modify hero_banner_widget.dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(/* custom gradient */),
  ),
  child: Column(
    children: [
      // Custom content
    ],
  ),
),
```

## 🔧 **Key Features**

### **Responsive Design**
- Adapts to different screen sizes
- Flexible grid layouts
- Responsive typography
- Touch-friendly interactions

### **Performance Optimizations**
- Lazy loading of images
- Efficient scroll listeners
- Minimal rebuilds
- Memory management

### **User Experience**
- Smooth animations
- Intuitive navigation
- Quick product access
- Visual feedback

## 🐛 **Troubleshooting**

### **Common Issues**
1. **Images not loading**: Check asset paths in `pubspec.yaml`
2. **Scroll performance**: Reduce scroll listener frequency
3. **Navigation errors**: Verify route definitions

### **Debug Tips**
```dart
// Add debug prints for scroll behavior
print('Scroll position: ${_scrollController.position.pixels}');
print('Should show FAB: $shouldShow');
```

## 📊 **Analytics Integration**

### **Trackable Events**
- Page view
- Featured product taps
- "View All" button clicks
- Add to cart actions
- Search initiation

### **Implementation**
```dart
// Example analytics call
Analytics.track('featured_product_viewed', {
  'product_name': product['name'],
  'product_brand': product['brand'],
  'from_section': 'featured_carousel',
});
```

## 🔮 **Future Enhancements**

- [ ] Personalized product recommendations
- [ ] Seasonal banners and promotions
- [ ] User-specific featured products
- [ ] Social media integration
- [ ] Push notification integration
- [ ] A/B testing for layouts
- [ ] Real-time inventory updates
- [ ] Product wishlisting from home page

## 📈 **Performance Metrics**

- **Load Time**: < 2 seconds
- **Scroll Performance**: 60 FPS
- **Memory Usage**: Optimized for mobile
- **Network Requests**: Minimal and cached
