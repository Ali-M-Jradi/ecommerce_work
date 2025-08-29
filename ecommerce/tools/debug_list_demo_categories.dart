import 'package:ecommerce/pages/products_page/products_page_widgets/products_data_provider.dart';

void main() {
  final prods = ProductsDataProvider.getDemoProducts();
  print('Total demo products: \\${prods.length}');
  for (final p in prods) {
    print('id=\\${p['id']} | name=\\${p['name'] is Map ? p['name']['en'] : p['name']} | category=\\${p['category']}');
  }
}
