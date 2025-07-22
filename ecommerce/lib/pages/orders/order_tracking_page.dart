import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter/services.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/order_status_timeline.dart';
import 'widgets/order_details_section.dart';
import 'widgets/shipping_info_section.dart';
import 'widgets/customer_support_section.dart';

class OrderTrackingPage extends StatefulWidget {
  final String? orderId;

  const OrderTrackingPage({
    super.key,
    this.orderId,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Order? _order;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrder();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrder() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.orderId != null) {
        final orderService = OrderService.instance;
        final order = orderService.getOrderById(widget.orderId!);

        if (order != null) {
          setState(() {
            _order = order;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = AppLocalizations.of(context)?.orderNotFound(widget.orderId!) 
                ?? 'Order not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)?.orderIdMissing 
              ?? 'Order ID is missing';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _copyTrackingNumber() {
    if (_order?.trackingNumber != null) {
      Clipboard.setData(ClipboardData(text: _order!.trackingNumber!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.trackingNumberCopied 
                ?? 'Tracking number copied to clipboard',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _trackPackage() async {
    if (_order?.trackingNumber != null) {
      // This is a simplified version - in a real app you would use the carrier's API
      // For this example, we'll just open a generic tracking website
      final url = 'https://www.packagetrackr.com/track/${_order!.trackingNumber}';
      
      if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
        await url_launcher.launchUrl(Uri.parse(url));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)?.unableToTrackPackage 
                    ?? 'Unable to track package',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.orderTrackingTitle ?? 'Order Tracking'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: Text(localizations?.backToOrders ?? 'Back to Orders'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildOrderTrackingContent(context, colorScheme, isDark),
    );
  }

  Widget _buildOrderTrackingContent(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final localizations = AppLocalizations.of(context);
    final order = _order!;
    return RefreshIndicator(
      onRefresh: _loadOrder,
      color: colorScheme.primary,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header with order number and date
                  _buildOrderHeader(order, localizations, colorScheme, isDark),
                  // Divider for separation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1.2,
                      height: 24,
                    ),
                  ),
                  // Status timeline (scrollable)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surfaceVariant.withOpacity(0.7) : colorScheme.surface.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: OrderStatusTimeline(order: order),
                  ),
                  // Tracking information
                  if (order.trackingNumber != null &&
                      (order.status == OrderStatus.shipped || order.status == OrderStatus.delivered))
                    _buildTrackingInfo(order, localizations, colorScheme, isDark),
                ],
              ),
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.outlineVariant,
            indicatorColor: colorScheme.primary,
            tabs: [
              Tab(text: localizations?.orderDetailsTab ?? 'Details'),
              Tab(text: localizations?.shippingInfoTab ?? 'Shipping'),
              Tab(text: localizations?.supportTab ?? 'Support'),
            ],
          ),
          // Tab Content
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                OrderDetailsSection(order: order),
                ShippingInfoSection(order: order),
                CustomerSupportSection(orderId: order.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(Order order, AppLocalizations? localizations, ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order tracking icon
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.local_shipping,
              color: colorScheme.primary,
              size: 32,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations?.orderNumberLabel ?? 'Order Number',
                  style: TextStyle(
                    color: colorScheme.outlineVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                localizations?.orderDateLabel ?? 'Order Date',
                style: TextStyle(
                  color: colorScheme.outlineVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat.yMMMd().format(order.createdAt),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingInfo(Order order, AppLocalizations? localizations, ColorScheme colorScheme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.10 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.trackingInformation ?? 'Tracking Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.trackingNumberLabel ?? 'Tracking Number',
                      style: TextStyle(
                        color: colorScheme.outlineVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.trackingNumber ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, color: colorScheme.outlineVariant),
                onPressed: _copyTrackingNumber,
                tooltip: localizations?.copyTrackingNumber ?? 'Copy Tracking Number',
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _trackPackage,
            icon: Icon(Icons.local_shipping, color: colorScheme.onPrimary),
            label: Text(localizations?.trackPackage ?? 'Track Package'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }
}
