import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

class CustomerSupportSection extends StatefulWidget {
  final String orderId;

  const CustomerSupportSection({
    super.key,
    required this.orderId,
  });

  @override
  State<CustomerSupportSection> createState() => _CustomerSupportSectionState();
}

class _CustomerSupportSectionState extends State<CustomerSupportSection> {
  final TextEditingController _messageController = TextEditingController();
  final List<SupportMessage> _messages = [];
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final message = _messageController.text.trim();
    setState(() {
      _isSending = true;
      _messages.add(
        SupportMessage(
          isFromUser: true,
          message: message,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    // Simulate a response after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSending = false;
          _messages.add(
            SupportMessage(
              isFromUser: false,
              message: _getAutomaticResponse(message),
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  String _getAutomaticResponse(String message) {
    final localizations = AppLocalizations.of(context);
    final lowercaseMessage = message.toLowerCase();
    
    if (lowercaseMessage.contains('cancel') || lowercaseMessage.contains('refund')) {
      return localizations?.supportResponseCancelRefund ?? 
          'For cancellation or refund requests, please visit the order details page and select "Cancel Order" or "Request Refund" option if available. If not available, our team will review your request and get back to you within 24 hours.';
    } else if (lowercaseMessage.contains('late') || 
              lowercaseMessage.contains('delay') || 
              lowercaseMessage.contains('when')) {
      return localizations?.supportResponseDeliveryDelay ?? 
          'We apologize for any delay with your delivery. Based on our tracking information, your package is still in transit. Unexpected delays can sometimes occur due to weather or local delivery conditions. Please check back tomorrow for an updated delivery estimate.';
    } else if (lowercaseMessage.contains('wrong') || 
              lowercaseMessage.contains('damage') || 
              lowercaseMessage.contains('broken')) {
      return localizations?.supportResponseDamagedOrder ?? 
          "We're sorry to hear about issues with your order. Please take photos of the damaged or incorrect items and email them to support@dermocosmetique.com along with your order number. Our customer service team will process a replacement or refund within 1-2 business days.";
    } else {
      return 'Thank you for contacting customer support regarding Order #${widget.orderId}. A support representative will review your message and respond within 24 hours. If you need immediate assistance, please call our customer service line at 1-800-555-0123.';
    }
  }

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: widget.orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.orderIdCopied ?? 'Order ID copied to clipboard',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Support Info
          _buildSupportInfo(context),
          
          const SizedBox(height: 24),
          
          // Chat Area Title
          Text(
            localizations?.contactSupportTitle ?? 'Contact Support',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyChatState(context)
                : _buildMessagesList(),
          ),
          
          // Message Input
          _buildMessageInput(context, theme),
        ],
      ),
    );
  }

  Widget _buildSupportInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations?.orderReferenceLabel ?? 'Order Reference',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Text(
                    '#${widget.orderId.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: _copyOrderId,
                    tooltip: localizations?.copyOrderId ?? 'Copy Order ID',
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            localizations?.supportAvailabilityTitle ?? 'Support Availability',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                localizations?.supportAvailabilityHours ?? 'Monday-Friday: 9am-6pm',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                localizations?.supportPhoneNumber ?? '1-800-555-0123',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                localizations?.supportEmailAddress ?? 'support@dermocosmetique.com',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatState(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            localizations?.startConversation ?? 'Start a conversation',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations?.supportResponseTimeMessage ?? 'Our team typically responds within 24 hours',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[_messages.length - 1 - index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(SupportMessage message) {
    final theme = Theme.of(context);
    
    return Align(
      alignment: message.isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isFromUser 
              ? theme.primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isFromUser ? const Radius.circular(0) : null,
            bottomLeft: !message.isFromUser ? const Radius.circular(0) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: message.isFromUser ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isFromUser 
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: localizations?.typeMessageHint ?? 'Type your message...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: _isSending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.send,
                    color: theme.primaryColor,
                  ),
            onPressed: _isSending ? null : _sendMessage,
            tooltip: localizations?.sendMessage ?? 'Send Message',
          ),
        ],
      ),
    );
  }
}

class SupportMessage {
  final bool isFromUser;
  final String message;
  final DateTime timestamp;

  SupportMessage({
    required this.isFromUser,
    required this.message,
    required this.timestamp,
  });
}
