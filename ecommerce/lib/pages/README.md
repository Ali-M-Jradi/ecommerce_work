# 📱 Ecommerce App Pages

This directory contains all the pages and screens for the DERMOCOSMETIQUE ecommerce Flutter application.

## 🏗️ **Page Structure**

```
pages/
├── base_page/              # Main app structure with navigation
├── home_page/              # Landing page with featured products
├── products_page/          # Product catalog with search & filters
├── cart_page/              # Shopping cart management
└── README.md              # This file
```

## 🎯 **Page Overview**

### **1. Base Page** 
- Main app scaffold with navigation
- Bottom navigation bar
- Drawer menu
- App bar with cart badge
- Floating action buttons

### **2. Home Page**
- Featured products carousel
- Category navigation
- Welcome banner
- Quick access to products

### **3. Products Page**
- Product grid/list view
- Search functionality
- Advanced filtering (brand, price, rating)
- Sort options
- Product details dialog

### **4. Cart Page**
- Cart item management
- Quantity controls
- Remove items functionality
- Cart summary with totals
- Checkout button

## 🚀 **Navigation Flow**

```
Home Page → Products Page → Product Details → Add to Cart → Cart Page
    ↓           ↓              ↓              ↓           ↓
Featured    Search &       View Details   Add Items   Manage Cart
Products    Filters        & Reviews      to Cart     & Checkout
```

## 📦 **State Management**

- **Provider Pattern**: Used for cart state management
- **CartProvider**: Manages cart items, quantities, totals
- **Controllers**: Page-specific state management

## 🎨 **Design Consistency**

- **Color Scheme**: Deep purple accent (#6200EA)
- **Typography**: Roboto font family
- **Components**: Reusable widgets in each page's widget folder
- **Material Design**: Follows Material 3 guidelines

## 🔧 **Key Features**

- ✅ Responsive design
- ✅ Real-time cart updates
- ✅ Search with highlighting
- ✅ Advanced filtering
- ✅ Product recommendations
- ✅ Smooth navigation
- ✅ Error handling
- ✅ Loading states

## 📚 **Documentation**

Each page has its own README.md file with detailed documentation:
- Component structure
- Widget hierarchy
- State management
- Navigation patterns
- Customization options
