import 'package:flutter/material.dart';

// Assuming you have these models and repository files in your project
import 'package:loginappv2/src/features/properties/Repositories/property_repo.dart';
import 'package:loginappv2/src/features/properties/models/model_property.dart';

/// A simple screen to fetch and display a list of properties.
class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  // 1. Initialize the Repository
  final PropertyRepository _repository = PropertyRepository();

  // 2. State variables to hold the data, loading status, and error
  List<PropertyModel> _properties = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // 3. Start fetching data when the widget is created
    _fetchProperties();
  }

  /// Async method to call the repository and update the state
  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true; // Set loading state
      _error = null;
    });

    try {
      // 4. Call the GET method from the repository
      final fetchedProperties = await _repository.fetchAllProperties();

      // 5. Update the UI with the fetched data
      setState(() {
        _properties = fetchedProperties;
        _isLoading = false;
      });
    } catch (e) {
      // 6. Handle errors and update the UI
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProperties, // Refresh button calls the fetch method
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              Text(
                'Error fetching data: $_error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchProperties,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_properties.isEmpty) {
      return const Center(child: Text('No properties found.'));
    }

    // 7. Display the data using a ListView
    return ListView.builder(
      itemCount: _properties.length,
      itemBuilder: (context, index) {
        final property = _properties[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 2,
          child: ListTile(
            leading: property.upload_photo_url != null
                ? Image.network(
              property.upload_photo_url!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.home),
            )
                : const Icon(Icons.home),
            title: Text(property.property_title ?? 'Untitled Property'),
            subtitle: Text(
                'Rent: \$${property.rent ?? 'N/A'} / ${property.rental_period ?? 'month'}'),
            trailing: Text(property.size ?? 'Unknown Size'),
            onTap: () {
              // TODO: Navigate to property details screen
              print('Tapped on ${property.property_title}');
            },
          ),
        );
      },
    );
  }
}