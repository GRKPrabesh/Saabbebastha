import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/booking.dart';
import '../models/service.dart';
import '../models/staff.dart';
import 'edit_service_page.dart';
import 'staff_management_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  List<User> _users = [];
  List<Booking> _bookings = [];
  List<Service> _services = [];
  List<Staff> _staff = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await ApiService.getAllUsers();
      final bookings = await ApiService.getBookings();
      final services = await ApiService.getServices();
      final staff = await ApiService.getStaff();

      setState(() {
        _users = users;
        _bookings = bookings;
        _services = services;
        _staff = staff;
        _isLoading = false;
      });

      // Show message if no bookings found
      if (bookings.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No bookings found. Bookings will appear here when customers make reservations.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.black),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StaffManagementPage()),
              );
              _loadData();
            },
            tooltip: 'Manage Staff',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildBookingsTab(),
                _buildCustomersTab(),
                _buildServicesTab(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Services',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bookings will appear here when customers make reservations',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(booking.service?.title ?? 'Service'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: ${booking.user?.fullName ?? 'N/A'}'),
                        Text('Date: ${booking.bookingDate.toString().split(' ')[0]}'),
                        Text('Status: ${booking.status}'),
                        if (booking.deceasedName.isNotEmpty)
                          Text('Deceased: ${booking.deceasedName}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person_add, color: Colors.blue),
                          onPressed: () => _assignStaff(booking),
                          tooltip: 'Assign Staff',
                        ),
                        PopupMenuButton<String>(
                          onSelected: (status) => _updateBookingStatus(booking.id, status),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'pending',
                              child: Text('Pending'),
                            ),
                            const PopupMenuItem(
                              value: 'confirmed',
                              child: Text('Confirmed'),
                            ),
                            const PopupMenuItem(
                              value: 'completed',
                              child: Text('Completed'),
                            ),
                            const PopupMenuItem(
                              value: 'cancelled',
                              child: Text('Cancelled'),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.status).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(booking.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Amount', '\$${booking.totalAmount.toStringAsFixed(2)}'),
                            _buildInfoRow('Payment', booking.paymentStatus),
                            if (booking.relationship.isNotEmpty)
                              _buildInfoRow('Relationship', booking.relationship),
                            if (booking.notes.isNotEmpty)
                              _buildInfoRow('Notes', booking.notes),
                            if (booking.assignedStaff != null) ...[
                              _buildInfoRow('Assigned Staff', booking.assignedStaff!.fullName),
                              _buildInfoRow('Staff Email', booking.assignedStaff!.email),
                              _buildInfoRow('Staff Phone', booking.assignedStaff!.phone),
                            ] else
                              _buildInfoRow('Assigned Staff', 'Not assigned'),
                            if (booking.customLocation != null) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Custom Location:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Address: ${booking.customLocation!['address'] ?? 'N/A'}'),
                              Text(
                                'Coordinates: ${booking.customLocation!['latitude']?.toStringAsFixed(6)}, ${booking.customLocation!['longitude']?.toStringAsFixed(6)}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCustomersTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _users.isEmpty
          ? const Center(
              child: Text('No customers found'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user.role == 'admin' ? Colors.blue : Colors.green,
                      child: Text(
                        user.firstName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(user.phone),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: user.role == 'admin' ? Colors.blue.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                          color: user.role == 'admin' ? Colors.blue.shade700 : Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildServicesTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _services.isEmpty
          ? const Center(
              child: Text('No services found'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: service.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              service.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.image, color: Colors.grey.shade600),
                                );
                              },
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.image, color: Colors.grey.shade600),
                          ),
                    title: Text(
                      service.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${service.price.toStringAsFixed(0)}'),
                        Text('Duration: ${service.duration}'),
                        Text('Type: ${service.serviceType.replaceAll('_', ' ').toUpperCase()}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditServicePage(service: service),
                              ),
                            );
                            if (result == true) {
                              _loadData();
                            }
                          },
                        ),
                        service.isActive
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    final result = await ApiService.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking status updated to $status'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to update status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _assignStaff(Booking booking) async {
    final activeStaff = _staff.where((s) => s.isActive).toList();
    
    if (activeStaff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active staff available. Please add staff members first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Staff'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activeStaff.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: const Text('Unassign Staff', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _updateBookingWithStaff(booking.id, null);
                  },
                );
              }
              final staff = activeStaff[index - 1];
              final isAssigned = booking.assignedStaff?.id == staff.id;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAssigned ? Colors.green : Colors.blue,
                  child: Text(staff.firstName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                title: Text(staff.fullName),
                subtitle: Text('${staff.email} - ${staff.role}'),
                trailing: isAssigned ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () async {
                  Navigator.pop(context);
                  await _updateBookingWithStaff(booking.id, staff.id);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateBookingWithStaff(String bookingId, String? staffId) async {
    final result = await ApiService.updateBookingStatus(
      bookingId: bookingId,
      status: _bookings.firstWhere((b) => b.id == bookingId).status,
      assignedStaffId: staffId,
    );

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(staffId == null ? 'Staff unassigned' : 'Staff assigned successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to assign staff'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

