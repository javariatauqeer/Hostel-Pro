import 'package:flutter/material.dart';

import '../models/hostel_models.dart';
import '../services/hostel_repository.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key, required this.user});

  final HostelUser user;

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      StudentHomeScreen(student: widget.user),
      StudentRoomsScreen(student: widget.user),
      StudentFeesScreen(student: widget.user),
      StudentComplaintsScreen(student: widget.user),
      StudentProfileScreen(student: widget.user),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room_rounded), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), selectedIcon: Icon(Icons.payments_rounded), label: 'Fees'),
          NavigationDestination(icon: Icon(Icons.report_problem_outlined), selectedIcon: Icon(Icons.report_problem_rounded), label: 'Complaints'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key, required this.student});

  final HostelUser student;

  @override
  Widget build(BuildContext context) {
    final announcements = HostelRepository.instance.announcements;
    final notifications = HostelRepository.instance.notifications;
    final complaints = HostelRepository.instance.complaintsForStudent(student.id);
    final feeRecords = HostelRepository.instance.feeRecordsForStudent(student.id);
    final latestFee = feeRecords.isNotEmpty ? feeRecords.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => _showNotifications(context),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              if (notifications.any((item) => !item.isRead))
                Positioned(
                  right: 9,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${student.name.split(' ').first}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF12384D)),
            ),
            const SizedBox(height: 6),
            const Text('Your hostel overview and updates', style: TextStyle(color: Color(0xFF61747F))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3D52),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current allocation', style: TextStyle(color: Color(0xFFDDEAF1), fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(
                          student.roomNumber ?? 'Awaiting allocation',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bed ${student.bedNumber ?? '—'} • ${student.hostelName ?? 'Pending assignment'}',
                          style: const TextStyle(fontSize: 13, color: Color(0xFFDAEAF2)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.bed_rounded, size: 34, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _InfoCard(
                  title: 'Fee status',
                  value: latestFee == null ? 'No record' : latestFee.status.name,
                  subtitle: latestFee == null ? 'Awaiting record' : 'Due ${_formatDate(latestFee.dueDate)}',
                  color: const Color(0xFF1D8F7F),
                  icon: Icons.account_balance_wallet_rounded,
                ),
                _InfoCard(
                  title: 'Complaint',
                  value: complaints.isEmpty ? 'None' : complaints.first.status.name,
                  subtitle: complaints.isEmpty ? 'No active issues' : complaints.first.category,
                  color: const Color(0xFF4C76D9),
                  icon: Icons.support_agent_rounded,
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text('Quick actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _ActionTile(icon: Icons.meeting_room_rounded, title: 'Rooms', subtitle: 'View and request'),
                  _ActionTile(icon: Icons.payment_rounded, title: 'Fees', subtitle: 'See payments'),
                  _ActionTile(icon: Icons.report_problem_rounded, title: 'Complaints', subtitle: 'Track issues'),
                  _ActionTile(icon: Icons.person_pin_circle_rounded, title: 'Profile', subtitle: 'Update info'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF12384D))),
            const SizedBox(height: 10),
            ...announcements.take(3).map(
              (announcement) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5EBF1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _priorityColor(announcement.priority).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.campaign_rounded, color: _priorityColor(announcement.priority)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF12384D)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            announcement.message,
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF627986)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _priorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return const Color(0xFFE35A5A);
      case AnnouncementPriority.medium:
        return const Color(0xFFF0B24B);
      case AnnouncementPriority.low:
        return const Color(0xFF3A8F7A);
    }
  }

  void _showNotifications(BuildContext context) {
    final notifications = HostelRepository.instance.notifications;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
              const SizedBox(height: 16),
              if (notifications.isEmpty)
                const Text('No notifications right now.')
              else
                ...notifications.map((notification) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      notification.isRead ? Icons.check_circle : Icons.notifications_active,
                      color: notification.isRead ? const Color(0xFF3A8F7A) : const Color(0xFF0F3D52),
                    ),
                    title: Text(notification.title),
                    subtitle: Text(notification.message),
                    onTap: () {
                      HostelRepository.instance.markNotificationRead(notification.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notification marked as read.')),
                      );
                    },
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class StudentRoomsScreen extends StatefulWidget {
  const StudentRoomsScreen({super.key, required this.student});

  final HostelUser student;

  @override
  State<StudentRoomsScreen> createState() => _StudentRoomsScreenState();
}

class _StudentRoomsScreenState extends State<StudentRoomsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = HostelRepository.instance.rooms.where((room) {
      final matchesType = _selectedType == 'All' || room.type.name == _selectedType.toLowerCase();
      final matchesSearch = room.roomNumber.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Rooms & Bed Requests')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search room number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All room types')),
                DropdownMenuItem(value: 'Single', child: Text('Single')),
                DropdownMenuItem(value: 'Double', child: Text('Double')),
                DropdownMenuItem(value: 'Triple', child: Text('Triple')),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value ?? 'All');
              },
              decoration: const InputDecoration(
                labelText: 'Filter by type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (_, index) {
                  final room = rooms[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                room.roomNumber,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12384D)),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: room.isAvailable ? const Color(0xFFDCF1E9) : const Color(0xFFF7E7D5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  room.isAvailable ? 'Available' : 'Occupied',
                                  style: TextStyle(
                                    color: room.isAvailable ? const Color(0xFF107B60) : const Color(0xFF8E5D15),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('${room.type.name[0].toUpperCase()}${room.type.name.substring(1)} • ${room.floor}'),
                          const SizedBox(height: 8),
                          Text('Capacity: ${room.totalCapacity} • Occupied: ${room.occupiedBeds} • Available: ${room.availableBeds}'),
                          const SizedBox(height: 8),
                          Text('Hostel fee: ₦${room.hostelFee.toStringAsFixed(0)} / term'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: room.facilities
                                .map((facility) => Chip(label: Text(facility, style: const TextStyle(fontSize: 11))))
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: room.isAvailable
                                  ? () => _requestRoom(context, room.roomNumber, room.type)
                                  : null,
                              icon: const Icon(Icons.add_home_rounded),
                              label: const Text('Request room / bed'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestRoom(BuildContext context, String roomNumber, RoomType roomType) {
    HostelRepository.instance.addRoomRequest(widget.student.id, roomNumber, roomType);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room request submitted for review.')),
    );
  }
}

class StudentFeesScreen extends StatelessWidget {
  const StudentFeesScreen({super.key, required this.student});

  final HostelUser student;

  @override
  Widget build(BuildContext context) {
    final records = HostelRepository.instance.feeRecordsForStudent(student.id);
    double totalPaid = 0;
    double totalDue = 0;
    for (final record in records) {
      totalPaid += record.paid;
      totalDue += record.total;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fees & Receipts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SummaryTile(label: 'Total', value: '₦${totalDue.toStringAsFixed(0)}', color: const Color(0xFF0F3D52)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryTile(label: 'Paid', value: '₦${totalPaid.toStringAsFixed(0)}', color: const Color(0xFF1D8F7F)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SummaryTile(
              label: 'Outstanding balance',
              value: '₦${(totalDue - totalPaid).toStringAsFixed(0)}',
              color: const Color(0xFFE35A5A),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Fee history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            ),
            const SizedBox(height: 10),
            if (records.isEmpty)
              const Text('No fee records found.')
            else
              ...records.map(
                (record) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(record.month, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _feeStatusColor(record.status).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                record.status.name.toUpperCase(),
                                style: TextStyle(
                                  color: _feeStatusColor(record.status),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Reference: ${record.reference}'),
                        Text('Due: ${_formatDate(record.dueDate)}'),
                        Text('Paid: ₦${record.paid.toStringAsFixed(0)} / Total: ₦${record.total.toStringAsFixed(0)}'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Color _feeStatusColor(FeeStatus status) {
    switch (status) {
      case FeeStatus.paid:
        return const Color(0xFF1D8F7F);
      case FeeStatus.pending:
        return const Color(0xFFF0B24B);
      case FeeStatus.overdue:
        return const Color(0xFFE35A5A);
    }
  }

  static String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class StudentComplaintsScreen extends StatefulWidget {
  const StudentComplaintsScreen({super.key, required this.student});

  final HostelUser student;

  @override
  State<StudentComplaintsScreen> createState() => _StudentComplaintsScreenState();
}

class _StudentComplaintsScreenState extends State<StudentComplaintsScreen> {
  final _descriptionController = TextEditingController();
  String _category = 'Electricity';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complaints = HostelRepository.instance.complaintsForStudent(widget.student.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Complaints & Maintenance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submit a complaint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _category,
              items: const [
                DropdownMenuItem(value: 'Electricity', child: Text('Electricity')),
                DropdownMenuItem(value: 'Water', child: Text('Water')),
                DropdownMenuItem(value: 'Cleanliness', child: Text('Cleanliness')),
                DropdownMenuItem(value: 'Furniture', child: Text('Furniture')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => _category = value ?? 'Electricity'),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Describe the issue',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  if (_descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please provide a complaint description.')),
                    );
                    return;
                  }
                  HostelRepository.instance.submitComplaint(
                    widget.student.id,
                    _category,
                    _descriptionController.text.trim(),
                  );
                  _descriptionController.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Complaint submitted successfully.')),
                  );
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Submit complaint'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Complaint history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            if (complaints.isEmpty)
              const Text('No complaint history yet.')
            else
              ...complaints.map(
                (complaint) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(complaint.category, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDAF5F0),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                complaint.status.name,
                                style: const TextStyle(color: Color(0xFF0E7667), fontWeight: FontWeight.w700, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(complaint.description),
                        const SizedBox(height: 8),
                        Text('Date: ${_formatDate(complaint.submittedAt)}'),
                        if (complaint.assignedStaff != null) Text('Assigned staff: ${complaint.assignedStaff}'),
                        if (complaint.resolutionNote != null) Text('Resolution: ${complaint.resolutionNote}'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key, required this.student});

  final HostelUser student;

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late final TextEditingController _phoneController;
  late final TextEditingController _emergencyController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.student.phone ?? '');
    _emergencyController = TextEditingController(text: widget.student.emergencyContact ?? '');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Student information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileRow(label: 'Student ID', value: widget.student.studentId ?? '—'),
                    _ProfileRow(label: 'Full name', value: widget.student.name),
                    _ProfileRow(label: 'Department', value: widget.student.department ?? '—'),
                    _ProfileRow(label: 'Semester', value: widget.student.semester?.toString() ?? '—'),
                    _ProfileRow(label: 'Hostel', value: widget.student.hostelName ?? 'Pending'),
                    _ProfileRow(label: 'Room', value: widget.student.roomNumber ?? 'Pending'),
                    _ProfileRow(label: 'Bed', value: widget.student.bedNumber ?? 'Pending'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Update contact details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emergencyController,
              decoration: const InputDecoration(labelText: 'Emergency contact', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully.')),
                  );
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2EBF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF61747F))),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6D7C88))),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EBF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0F3D52).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0F3D52)),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF12384D))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF647884))),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5B6E79)))),
          Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF12384D), fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
