import 'package:ecommerce/pages/base_page/base_page_widgets/footer_widget.dart';
import 'package:ecommerce/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.deepPurpleAccent.shade700,
              ),
              border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.deepPurpleAccent.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.deepPurpleAccent.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent.shade700,
                  width: 2.0,
                ),
              ),
              hintText: 'Search products',
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        const Expanded(
          child: HomePage(),
        ),
        const FooterWidget(),
      ],
    );
  }
}
