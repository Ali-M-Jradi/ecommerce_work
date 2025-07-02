class ProductsDataProvider {
  static List<Map<String, dynamic>> getDemoProducts() {
    return [
      {
        'brand': 'Avène',
        'name': 'Thermal Spring Water Face Mist',
        'description': 'A soothing and anti-irritating thermal spring water mist that provides instant relief and comfort for sensitive skin. Rich in minerals and silicates for optimal skin health.',
        'size': '150ml',
        'price': '12.99',
        'rating': '4.5',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'La Roche-Posay',
        'name': 'Toleriane Double Repair Face Moisturizer with SPF 30',
        'description': 'A daily moisturizer with broad-spectrum SPF 30 sunscreen that provides all-day hydration while protecting against UV rays. Formulated with ceramides and niacinamide for barrier repair.',
        'size': '75ml',
        'price': '19.99',
        'rating': '4.7',
        'soldOut': true,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Vichy',
        'name': 'Mineral 89 Hyaluronic Acid Face Serum',
        'description': 'A powerful hyaluronic acid serum fortified with 89% Vichy volcanic water and natural origin hyaluronic acid to strengthen and plump skin for 24-hour hydration.',
        'size': '30ml',
        'price': '29.99',
        'rating': '4.3',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Eucerin',
        'name': 'Daily Protection Face Lotion SPF 30',
        'description': 'A lightweight, non-greasy daily moisturizer with broad-spectrum SPF 30. Provides 24-hour hydration while protecting against harmful UVA/UVB rays and environmental damage.',
        'size': '120ml',
        'price': '14.99',
        'rating': '4.2',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Avène',
        'name': 'Gentle Milk Cleanser for Sensitive Skin',
        'description': 'A gentle, soap-free cleanser that removes makeup and impurities while respecting the skin\'s natural balance. Enriched with Avène thermal spring water for soothing benefits.',
        'size': '200ml',
        'price': '16.99',
        'rating': '4.6',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Bioderma',
        'name': 'Sensibio H2O Micellar Cleansing Water',
        'description': 'The original micellar water that gently cleanses and removes makeup from face and eyes. Specifically formulated for sensitive skin with a biomimetic formulation that respects skin ecology.',
        'size': '250ml',
        'price': '13.99',
        'rating': '4.8',
        'soldOut': true,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
    ];
  }

  static List<Map<String, dynamic>> getSortedProducts(String sortBy) {
    List<Map<String, dynamic>> products = List.from(getDemoProducts());
    
    switch (sortBy) {
      case 'A to Z':
        products.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));
        break;
      case 'Z to A':
        products.sort((a, b) => b['name'].toString().toLowerCase().compareTo(a['name'].toString().toLowerCase()));
        break;
      case 'Price Low':
        products.sort((a, b) => double.parse(a['price'].toString()).compareTo(double.parse(b['price'].toString())));
        break;
      case 'Price High':
        products.sort((a, b) => double.parse(b['price'].toString()).compareTo(double.parse(a['price'].toString())));
        break;
      default:
        // Default to A to Z if somehow an invalid sort option is selected
        products.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));
    }
    
    return products;
  }
}
