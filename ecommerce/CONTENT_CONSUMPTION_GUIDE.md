# 🚀 **API Content Consumption Guide**

## **Your Current Architecture is Perfect!**

Your `ContentProvider` + `ContentManager` structure already handles everything. Here's how to use it:

---

## **1. 📋 ContentProvider Methods Available**

```dart
// ✅ Already working methods in your ContentProvider:

// Load all content from API
await contentProvider.loadContent();

// Get organized data
final carouselImages = contentProvider.getCarouselImages();        // List<String>
final bannerTexts = contentProvider.getMovingBannerTexts();        // List<String>
final contactInfo = contentProvider.getContactInfo();              // Map<String, String>
final socialLinks = contentProvider.getSocialMediaLinks();         // Map<String, String>

// Get theme colors
final primaryColor = contentProvider.getPrimaryColor();            // Color
final secondaryColor = contentProvider.getSecondaryColor();        // Color
final thirdColor = contentProvider.getThirdColor();               // Color

// Get content by section
final homeContent = contentProvider.getPageContent('home');        // List<ContentItem>
final sectionContent = contentProvider.getSectionContent('home', 'featured-products');
```

---

## **2. 🎯 Quick Integration in Any Widget**

### **Step 1: Add Consumer**
```dart
Consumer<ContentProvider>(
  builder: (context, contentProvider, child) {
    if (contentProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    // Use the content here
    final carouselImages = contentProvider.getCarouselImages();
    final bannerTexts = contentProvider.getMovingBannerTexts();
    
    return YourWidget(images: carouselImages, texts: bannerTexts);
  },
)
```

### **Step 2: Load Content** 
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ContentProvider>().loadContent();
  });
}
```

---

## **3. 🖼️ Image Loading Pattern**

```dart
// For carousel images
final imageFilename = carouselImages[index];
final imageUrl = ContentService.getImageUrl(imageFilename);

ExtendedImage.network(
  imageUrl,
  fit: BoxFit.cover,
  cache: true,
  loadStateChanged: (ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return CircularProgressIndicator();
      case LoadState.completed:
        return ExtendedRawImage(
          image: state.extendedImageInfo?.image,
          fit: BoxFit.cover,
        );
      case LoadState.failed:
        return Column(
          children: [
            Icon(Icons.broken_image),
            Text('Image not available'),
          ],
        );
    }
  },
)
```

---

## **4. 📱 Content Organization Examples**

### **Hero Banner Carousel** (Already working!)
```dart
// In your hero_banner_carousel.dart
final carouselImages = contentProvider.getCarouselImages();
// ✅ This already works perfectly!
```

### **Moving Banner Texts**
```dart
final bannerTexts = contentProvider.getMovingBannerTexts();
PageView.builder(
  itemCount: bannerTexts.length,
  itemBuilder: (context, index) {
    return Center(
      child: Text(
        bannerTexts[index],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  },
)
```

### **Contact Information**
```dart
final contactInfo = contentProvider.getContactInfo();
ListTile(
  leading: Icon(Icons.phone),
  title: Text(contactInfo['phone'] ?? 'Not available'),
  onTap: () => _launchPhone(contactInfo['phone']),
),
ListTile(
  leading: Icon(Icons.email),
  title: Text(contactInfo['email'] ?? 'Not available'),
  onTap: () => _launchEmail(contactInfo['email']),
),
```

### **Theme Colors**
```dart
AppBar(
  backgroundColor: contentProvider.getPrimaryColor(),
  // ... rest of AppBar
),
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        contentProvider.getPrimaryColor(),
        contentProvider.getSecondaryColor(),
      ],
    ),
  ),
),
```

---

## **5. 🔄 Content Refresh Pattern**

```dart
// Pull to refresh
RefreshIndicator(
  onRefresh: () => contentProvider.refreshContent(),
  child: YourScrollableWidget(),
),

// Manual refresh button
ElevatedButton(
  onPressed: () => contentProvider.refreshContent(),
  child: Text('Refresh Content'),
)
```

---

## **6. 📊 Error Handling**

```dart
Consumer<ContentProvider>(
  builder: (context, contentProvider, child) {
    if (contentProvider.error != null) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error),
            Text('Error: ${contentProvider.error}'),
            ElevatedButton(
              onPressed: () => contentProvider.refreshContent(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // Success state
    return YourContentWidget();
  },
)
```

---

## **7. 🚀 Quick Start Checklist**

- [x] ✅ ContentProvider - Working
- [x] ✅ ContentService - Working  
- [x] ✅ ContentManager - Working
- [x] ✅ WebP support added
- [x] ✅ API structure ready
- [ ] 🔄 Add Consumer widgets to your pages
- [ ] 🔄 Call `loadContent()` in initState
- [ ] 🔄 Use getter methods for specific content

---

## **8. 💡 Pro Tips**

1. **Loading State**: Always show loading indicators
2. **Error Handling**: Provide retry buttons
3. **Caching**: ExtendedImage handles image caching
4. **Performance**: Use `Consumer` only where needed
5. **Refresh**: Add pull-to-refresh for better UX

---

## **9. 🎯 Ready-to-Use Examples**

- `content_consumption_examples.dart` - Complete showcase
- `complete_home_page.dart` - Practical implementation
- Your existing `hero_banner_carousel.dart` - Already perfect!

**Your architecture is excellent! Just add Consumer widgets and call the getter methods.** 🚀
