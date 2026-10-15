import 'package:flutter/material.dart';

import '../models/hostel_models.dart';
import '../services/hostel_repository.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboardScreen(),
      const AdminStudentsScreen(),
      const AdminRoomsScreen(),
      const AdminFeesScreen(),
      const AdminComplaintsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people_rounded), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room_rounded), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), selectedIcon: Icon(Icons.wallet_rounded), label: 'Fees'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent_rounded), label: 'Complaints'),
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = HostelRepository.instance.adminStats();
    final visitors = HostelRepository.instance.visitors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Overview'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hostel metrics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _MetricCard(title: 'Students', value: '${stats['students']}', accent: const Color(0xFF0F3D52)),
                _MetricCard(title: 'Rooms', value: '${stats['rooms']}', accent: const Color(0xFF2A7F97)),
                _MetricCard(title: 'Occupied beds', value: '${stats['occupiedBeds']}', accent: const Color(0xFF1D8F7F)),
                _MetricCard(title: 'Available beds', value: '${stats['availableBeds']}', accent: const Color(0xFF4A78D9)),
                _MetricCard(title: 'Occupancy', value: '${stats['occupancy'].toStringAsFixed(0)}%', accent: const Color(0xFFF0B24B)),
                _MetricCard(title: 'Pending requests', value: '${stats['pendingRequests']}', accent: const Color(0xFFE35A5A)),
                _MetricCard(title: 'Outstanding fees', value: '₦${(stats['outstandingFees'] as double).toStringAsFixed(0)}', accent: const Color(0xFF8F5DFF)),
                _MetricCard(title: 'Pending complaints', value: '${stats['pendingComplaints']}', accent: const Color(0xFF7A8D6B)),
              ],
            ),
            const SizedBox(height: 22),
            const Text('Recent visitors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            ...visitors.take(3).map(
              (visitor) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                  title: Text(visitor.name),
                  subtitle: Text('${visitor.studentName} • ${visitor.purpose}'),
                  trailing: Text(visitor.status, style: const TextStyle(color: Color(0xFF0F3D52), fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminStudentsScreen extends StatelessWidget {
  const AdminStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = HostelRepository.instance.students;
    return Scaffold(
      appBar: AppBar(title: const Text('Student Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: students.length,
        itemBuilder: (_, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0F3D52),
                child: Text(student.name[0]),
              ),
              title: Text(student.name),
              subtitle: Text('${student.studentId ?? 'No ID'} • ${student.department ?? 'No dept'} • ${student.semester ?? 0}th sem'),
              trailing: Text(student.allocStatus.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          );
        },
      ),
    );
  }
}

class AdminRoomsScreen extends StatefulWidget {
  const AdminRoomsScreen({super.key});

  @override
  State<AdminRoomsScreen> createState() => _AdminRoomsScreenState();
}

class _AdminRoomsScreenState extends State<AdminRoomsScreen> {
  @override
  Widget build(BuildContext context) {
    final rooms = HostelRepository.instance.rooms;
    final requests = HostelRepository.instance.roomRequests;

    return Scaffold(
      appBar: AppBar(title: const Text('Room & Bed Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pending requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            if (requests.isEmpty)
              const Text('No pending requests.')
            else
              ...requests.map(
                (request) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.roomNumber, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Student: ${request.studentId} • Type: ${request.requestedRoomType.name}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            HostelRepository.instance.approveRoomRequest(request.id);
                            setState(() {});
                          },
                          child: const Text('Approve allocation'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text('Room inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12384D))),
            const SizedBox(height: 12),
            ...rooms.map(
              (room) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(room.roomNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: room.isAvailable ? const Color(0xFFDCF1E9) : const Color(0xFFEFE7D5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(room.isAvailable ? 'Available' : 'Occupied'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${room.type.name} • ${room.floor}'),
                      Text('Capacity ${room.totalCapacity} • Occupied ${room.occupiedBeds} • Available ${room.availableBeds}'),
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
}

class AdminFeesScreen extends StatelessWidget {
  const AdminFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = HostelRepository.instance.students;

    return Scaffold(
      appBar: AppBar(title: const Text('Fee Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: students.length,
        itemBuilder: (_, index) {
          final student = students[index];
          final feeRecords = HostelRepository.instance.feeRecordsForStudent(student.id);
          final recent = feeRecords.isNotEmpty ? feeRecords.first : null;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(student.name),
              subtitle: Text(recent == null ? 'No fee record' : '${recent.month} • ${recent.status.name}'),
              trailing: const Icon(Icons.receipt_long_rounded),
            ),
          );
        },
      ),
    );
  }
}

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  @override
  Widget build(BuildContext context) {
    final complaints = HostelRepository.instance.complaints;

    return Scaffold(
      appBar: AppBar(title: const Text('Complaints Board')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: complaints.length,
        itemBuilder: (_, index) {
          final complaint = complaints[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(complaint.category, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      Text(complaint.status.name),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(complaint.description),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () {
                          HostelRepository.instance.updateComplaintStatus(complaint.id, ComplaintStatus.inProgress);
                          setState(() {});
                        },
                        child: const Text('Mark in progress'),
                      ),
                      TextButton(
                        onPressed: () {
                          HostelRepository.instance.updateComplaintStatus(complaint.id, ComplaintStatus.resolved);
                          setState(() {});
                        },
                        child: const Text('Resolve'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: accent)),
        ],
      ),
    );
  }
}
