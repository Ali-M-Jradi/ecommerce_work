import 'package:ecommerce/pages/base_page/base_page_widgets/body.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/drawer_widget.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/floating_action_buttons_widget.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/app_bar.dart';
import 'package:ecommerce/pages/home_page/home_page.dart';
import 'package:ecommerce/pages/products_page/products_page.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.title});

  final String title;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF), // Purple-tinted white
      appBar: AppBarWidget(),
      body:  HomePage(),
      floatingActionButton: FloatingActionButtonsWidget(),
      drawer: DrawerWidget(),
    );
  }
}
