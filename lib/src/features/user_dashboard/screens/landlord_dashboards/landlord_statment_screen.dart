import 'package:flutter/material.dart';

// NOTE: You will need to add the esewa_flutter package to your pubspec.yaml:
// dependencies:
//   esewa_flutter: ^latest_version
//
// Then, you would use it like this (example of a payment initiation function):
/*
import 'package:esewa_flutter/esewa_flutter.dart';

Future<void> initiateEsewaPayment(BuildContext context) async {
  final esewa = EsewaFlutter.instance;

  final response = await esewa.pay(
    context: context,
    // Use the test environment for development
    configuration: PaymentConfiguration.test(
      // Landlord's unique service ID for collecting rent
      productServiceId: 'EPAYTEST',
      productServiceSecret: 'EPAYTEST',
      merchantId: 'EPAYTEST',
      productName: 'Monthly Rent Collection',
      productId: 'RENT-12345',
      amount: 100.0, // Example amount
    ),
  );

  if (response.isSuccess) {
    // Handle successful payment, e.g., update the transaction log in your state
    print('Payment Success: ${response.message}');
  } else {
    // Handle failure
    print('Payment Failed: ${response.message}');
  }
}
*/

// --- Mock Data and Constants ---
const Color kPrimaryColor = Color(0xFFF12929); // Red color from the image
const Color kSecondaryColor = Color(0xFF32C765); // Green eSewa/Success color
const Color kBackgroundColor = Color(0xFFF7F7F7);

// A simple model for a transaction to demonstrate the list structure
class Transaction {
  final String title;
  final String date;
  final double amount;
  final bool isDeposit;

  Transaction(this.title, this.date, this.amount, this.isDeposit);
}

// Mock list of transactions (replace with real data/Firestore in the future)
final List<Transaction> mockTransactions = [
  // Example of a successful rent deposit
  // Transaction('Rent from Tenant A', '2025-05-01', 15000.00, true),
  // Transaction('Utility Bill Payment', '2025-05-03', 2500.00, false),
];

class PaymentStatementScreen extends StatefulWidget {
  const PaymentStatementScreen({super.key});

  @override
  State<PaymentStatementScreen> createState() => _PaymentStatementScreenState();
}

class _PaymentStatementScreenState extends State<PaymentStatementScreen> {
  String _selectedTimeFilter = '7 days';
  String _selectedTypeFilter = 'All';
  bool _showBalance = true;
  // Note: I'm keeping the list empty here to show the Empty State by default,
  // consistent with the original image.
  final List<Transaction> _transactions = mockTransactions;

  // --- UI Components ---

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // eSewa Logo Placeholder (Use a real asset or icon later)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: kSecondaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              const Text(
                'NPR',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Text(
                _showBalance ? '150,000.50' : 'XXXXX.XX', // Mock Landlord Balance
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Hide/Show Balance Icon
              IconButton(
                icon: Icon(
                  _showBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showBalance = !_showBalance;
                  });
                },
              ),
              // Refresh Icon
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  // TODO: Implement data refresh logic here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> timeFilters = ['7 days', '15 days', '30 days', 'All Time'];
    final List<String> typeFilters = ['All', 'Deposit', 'Withdraw'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        children: [
          // Time Filters
          ...timeFilters.map((filter) => _buildChip(
            label: filter,
            isSelected: _selectedTimeFilter == filter,
            onTap: () {
              setState(() {
                _selectedTimeFilter = filter;
                // TODO: Implement filtering logic
              });
            },
          )),
          const SizedBox(width: 16),
          // Separator for visual grouping (like in the image)
          Container(width: 1, height: 20, color: Colors.grey[300]),
          const SizedBox(width: 16),
          // Type Filters
          ...typeFilters.map((filter) => _buildChip(
            label: filter,
            isSelected: _selectedTypeFilter == filter,
            onTap: () {
              setState(() {
                _selectedTypeFilter = filter;
                // TODO: Implement filtering logic
              });
            },
          )),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        backgroundColor: isSelected ? kPrimaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? kPrimaryColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Placeholder (mimicking the image's style)
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor.withOpacity(0.05),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.folder_off_outlined,
                    size: 100, color: kPrimaryColor.withOpacity(0.8)),
                Positioned(
                  top: 50,
                  right: 50,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.close,
                        size: 30, color: kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Sorry No Transaction Logs Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 50), // Reduced height since the NavBar is gone
          // Optional: A button to prompt the landlord to record a transaction or request rent
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // TODO: Navigate to 'Request Rent' or 'Record Payment' screen
          //     // For eSewa integration, you might call initiateEsewaPayment(context) here.
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Action: Collect Rent or View Pending Payments')),
          //     );
          //   },
          //   icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          //   label: const Text('Collect Rent', style: TextStyle(color: Colors.white)),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: kSecondaryColor,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          // ),
        ],
      ),
    );
  }

  // NOTE: _buildBottomNavBar, _buildNavItem, and _buildAddButton have been removed.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Rent Statements', // Contextual title for a Landlord app
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // Assuming an info or settings button if needed
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 12),
          _buildFilterChips(),
          const SizedBox(height: 20),
          Expanded(
            child: _transactions.isEmpty
                ? _buildEmptyState()
                : const Center(
              child: Text('Transaction List Goes Here'),
            ), // Or a ListView.builder for transactions
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomNavBar(), // REMOVED
    );
  }
}