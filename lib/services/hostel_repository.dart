import 'dart:math' as math;

import '../models/hostel_models.dart';

class HostelRepository {
  HostelRepository._();

  static final HostelRepository instance = HostelRepository._();

  final List<HostelUser> _users = [
    HostelUser(
      id: 'admin-1',
      name: 'Alicia Stone',
      email: 'admin@hms.com',
      password: 'admin123',
      role: UserRole.admin,
      phone: '+2348012345678',
      department: 'Administration',
      semester: null,
      studentId: 'ADMIN-001',
    ),
    HostelUser(
      id: 'student 1',
      name: 'Javaria Tauqeer',
      email: 'student@gmail.com',
      password: 'pass123',
      role: UserRole.student,
      phone: '+92455677889',
      department: 'Computer Science',
      semester: 3,
      studentId: 'CS-2048',
      roomNumber: 'A-204',
      bedNumber: 'B2',
      hostelName: 'AU Hostel',
      emergencyContact: 'Tauqeer • +9248123456789',
      allocStatus: AllocationStatus.approved,
      balance: 46000,
    ),
    HostelUser(
      id: 'student-2',
      name: 'Daniel Okafor',
      email: 'daniel@hms.com',
      password: 'pass123',
      role: UserRole.student,
      phone: '+2348099988776',
      department: 'Electrical Engineering',
      semester: 6,
      studentId: 'EE-3010',
      roomNumber: 'C-119',
      bedNumber: 'A1',
      hostelName: 'Blue Crest Hostel',
      emergencyContact: 'Grace Okafor • +2348156654321',
      allocStatus: AllocationStatus.approved,
      balance: 15000,
    ),
  ];

  final List<Room> _rooms = [
    Room(
      id: 'room-1',
      roomNumber: 'A-204',
      type: RoomType.double,
      totalCapacity: 2,
      occupiedBeds: 1,
      hostelFee: 65000,
      facilities: ['Study desk', 'Wardrobe', 'Air conditioning', 'Wi-Fi'],
      floor: '2nd Floor',
    ),
    Room(
      id: 'room-2',
      roomNumber: 'B-118',
      type: RoomType.single,
      totalCapacity: 1,
      occupiedBeds: 1,
      hostelFee: 72000,
      facilities: ['Private bath', 'Study desk', 'Reading lamp', 'Wi-Fi'],
      floor: '1st Floor',
    ),
    Room(
      id: 'room-3',
      roomNumber: 'C-119',
      type: RoomType.triple,
      totalCapacity: 3,
      occupiedBeds: 2,
      hostelFee: 60000,
      facilities: ['Shared bath', 'Hot water', 'Laundry', 'Wardrobe'],
      floor: '1st Floor',
    ),
    Room(
      id: 'room-4',
      roomNumber: 'D-305',
      type: RoomType.double,
      totalCapacity: 2,
      occupiedBeds: 0,
      hostelFee: 68000,
      facilities: ['Window fan', 'Reading chair', 'Wi-Fi', 'Storage shelf'],
      floor: '3rd Floor',
    ),
  ];

  final List<RoomRequest> _roomRequests = [
    RoomRequest(
      id: 'req-1',
      studentId: 'student-2',
      roomNumber: 'D-305',
      requestedRoomType: RoomType.double,
      status: AllocationStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    RoomRequest(
      id: 'req-2',
      studentId: 'student-1',
      roomNumber: 'A-204',
      requestedRoomType: RoomType.double,
      status: AllocationStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  final List<FeeRecord> _fees = [
    FeeRecord(
      id: 'fee-1',
      studentId: 'student-1',
      month: 'September 2026',
      total: 65000,
      paid: 25000,
      dueDate: DateTime(2026, 9, 22),
      status: FeeStatus.pending,
      reference: 'REF-6021',
    ),
    FeeRecord(
      id: 'fee-2',
      studentId: 'student-1',
      month: 'October 2026',
      total: 65000,
      paid: 40000,
      dueDate: DateTime(2026, 10, 15),
      status: FeeStatus.pending,
      reference: 'REF-6188',
    ),
    FeeRecord(
      id: 'fee-3',
      studentId: 'student-2',
      total: 60000,
      month: 'October 2026',
      paid: 60000,
      dueDate: DateTime(2026, 10, 12),
      status: FeeStatus.paid,
      reference: 'REF-7012',
    ),
  ];

  final List<Complaint> _complaints = [
    Complaint(
      id: 'complaint-1',
      studentId: 'student-1',
      category: 'Electricity',
      description: 'The lighting in the corridor flickers after 9:00pm.',
      submittedAt: DateTime.now().subtract(const Duration(days: 4)),
      status: ComplaintStatus.pending,
      assignedStaff: 'Maintenance Team',
    ),
    Complaint(
      id: 'complaint-2',
      studentId: 'student-2',
      category: 'Cleanliness',
      description: 'Bathroom drains are clogged and need cleaning.',
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: ComplaintStatus.inProgress,
      assignedStaff: 'Sanitation Desk',
      resolutionNote: 'Plumber scheduled for tomorrow.',
    ),
  ];

  final List<Announcement> _announcements = [
    Announcement(
      id: 'announcement-1',
      title: 'Fee Reminder',
      message: 'All hostel fees for October are due before 15th of the month.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      priority: AnnouncementPriority.high,
      category: 'Fees',
    ),
    Announcement(
      id: 'announcement-2',
      title: 'Water Supply Update',
      message: 'A maintenance routine will affect water pressure in Block C tomorrow morning.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      priority: AnnouncementPriority.medium,
      category: 'Maintenance',
    ),
    Announcement(
      id: 'announcement-3',
      title: 'Hostel Rules',
      message: 'Visitors must leave by 7:00 PM and present valid ID at the security gate.',
      date: DateTime.now().subtract(const Duration(days: 8)),
      priority: AnnouncementPriority.low,
      category: 'Rules',
    ),
  ];

  final List<VisitorLog> _visitors = [
    VisitorLog(
      id: 'vis-1',
      name: 'Tina Adedayo',
      studentName: 'Amina Bello',
      purpose: 'Family visit',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'Approved',
    ),
    VisitorLog(
      id: 'vis-2',
      name: 'Chima Eze',
      studentName: 'Daniel Okafor',
      purpose: 'Project discussion',
      time: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Pending',
    ),
  ];

  final List<LeaveRequest> _leaveRequests = [
    LeaveRequest(
      id: 'leave-1',
      studentId: 'student-1',
      reason: 'Weekend family visit',
      startDate: DateTime(2026, 10, 21),
      endDate: DateTime(2026, 10, 24),
      status: AllocationStatus.pending,
    ),
  ];

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'note-1',
      title: 'Room request update',
      message: 'Your request for a single room was reviewed by the hostel admin.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: 'note-2',
      title: 'Fee due soon',
      message: 'Your payment due date is in 3 days.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  HostelUser? authenticate(String email, String password) {
    for (final user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase() &&
          user.password == password) {
        return user;
      }
    }
    return null;
  }

  HostelUser? registerStudent({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String department,
    required int semester,
    required String studentId,
  }) {
    final existing = _users.any((user) => user.email.toLowerCase() == email.trim().toLowerCase());
    if (existing) {
      return null;
    }

    final newUser = HostelUser(
      id: 'student-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email.trim(),
      password: password,
      role: UserRole.student,
      phone: phone,
      department: department,
      semester: semester,
      studentId: studentId,
      emergencyContact: 'Unassigned',
      allocStatus: AllocationStatus.pending,
      balance: 0,
    );
    _users.add(newUser);
    return newUser;
  }

  List<HostelUser> get students => _users.where((user) => user.role == UserRole.student).toList();
  List<HostelUser> get admins => _users.where((user) => user.role == UserRole.admin).toList();
  List<Room> get rooms => List.unmodifiable(_rooms);
  List<Announcement> get announcements => List.unmodifiable(_announcements);
  List<Complaint> get complaints => List.unmodifiable(_complaints);
  List<FeeRecord> get feeRecords => List.unmodifiable(_fees);
  List<VisitorLog> get visitors => List.unmodifiable(_visitors);
  List<LeaveRequest> get leaveRequests => List.unmodifiable(_leaveRequests);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  List<RoomRequest> get roomRequests => List.unmodifiable(_roomRequests);

  HostelUser? getStudentById(String studentId) {
    try {
      return _users.firstWhere((user) => user.id == studentId);
    } catch (_) {
      return null;
    }
  }

  List<FeeRecord> feeRecordsForStudent(String studentId) {
    return _fees.where((fee) => fee.studentId == studentId).toList();
  }

  List<Complaint> complaintsForStudent(String studentId) {
    return _complaints.where((complaint) => complaint.studentId == studentId).toList();
  }

  void addRoomRequest(String studentId, String roomNumber, RoomType requestedRoomType) {
    _roomRequests.add(
      RoomRequest(
        id: 'req-${math.Random().nextInt(9999)}',
        studentId: studentId,
        roomNumber: roomNumber,
        requestedRoomType: requestedRoomType,
        status: AllocationStatus.pending,
        createdAt: DateTime.now(),
      ),
    );
  }

  void submitComplaint(String studentId, String category, String description) {
    _complaints.add(
      Complaint(
        id: 'complaint-${math.Random().nextInt(9999)}',
        studentId: studentId,
        category: category,
        description: description,
        submittedAt: DateTime.now(),
        status: ComplaintStatus.pending,
      ),
    );
  }

  void addLeaveRequest(String studentId, String reason, DateTime startDate, DateTime endDate) {
    _leaveRequests.add(
      LeaveRequest(
        id: 'leave-${math.Random().nextInt(9999)}',
        studentId: studentId,
        reason: reason,
        startDate: startDate,
        endDate: endDate,
        status: AllocationStatus.pending,
      ),
    );
  }

  void updateComplaintStatus(String complaintId, ComplaintStatus status) {
    final index = _complaints.indexWhere((complaint) => complaint.id == complaintId);
    if (index != -1) {
      final complaint = _complaints[index];
      _complaints[index] = Complaint(
        id: complaint.id,
        studentId: complaint.studentId,
        category: complaint.category,
        description: complaint.description,
        submittedAt: complaint.submittedAt,
        status: status,
        assignedStaff: complaint.assignedStaff,
        resolutionNote: status == ComplaintStatus.resolved ? 'Resolved by admin.' : complaint.resolutionNote,
      );
    }
  }

  void approveRoomRequest(String requestId) {
    final index = _roomRequests.indexWhere((request) => request.id == requestId);
    if (index != -1) {
      final request = _roomRequests[index];
      _roomRequests[index] = RoomRequest(
        id: request.id,
        studentId: request.studentId,
        roomNumber: request.roomNumber,
        requestedRoomType: request.requestedRoomType,
        status: AllocationStatus.approved,
        createdAt: request.createdAt,
      );
      final user = getStudentById(request.studentId);
      if (user != null) {
        final currentIndex = _users.indexWhere((item) => item.id == user.id);
        if (currentIndex != -1) {
          _users[currentIndex] = user.copyWith(
            roomNumber: request.roomNumber,
            bedNumber: 'A${math.Random().nextInt(3) + 1}',
            allocStatus: AllocationStatus.approved,
            hostelName: 'Blue Crest Hostel',
          );
        }
      }
    }
  }

  void markNotificationRead(String notificationId) {
    final index = _notifications.indexWhere((notification) => notification.id == notificationId);
    if (index != -1) {
      final item = _notifications[index];
      _notifications[index] = NotificationItem(
        id: item.id,
        title: item.title,
        message: item.message,
        createdAt: item.createdAt,
        isRead: true,
      );
    }
  }

  Map<String, dynamic> adminStats() {
    final studentsCount = students.length;
    final totalRooms = _rooms.length;
    final totalBeds = _rooms.fold<int>(0, (sum, room) => sum + room.totalCapacity);
    final occupiedBeds = _rooms.fold<int>(0, (sum, room) => sum + room.occupiedBeds);
    final availableBeds = totalBeds - occupiedBeds;
    final pendingRequests = _roomRequests.where((request) => request.status == AllocationStatus.pending).length;
    final outstandingFees = _fees.where((fee) => fee.status != FeeStatus.paid).fold<double>(0, (sum, fee) => sum + fee.balance);
    final pendingComplaints = _complaints.where((complaint) => complaint.status != ComplaintStatus.resolved).length;
    final occupancy = totalBeds == 0 ? 0.0 : ((occupiedBeds / totalBeds) * 100).clamp(0, 100);

    return {
      'students': studentsCount,
      'rooms': totalRooms,
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
      'availableBeds': availableBeds,
      'occupancy': occupancy,
      'pendingRequests': pendingRequests,
      'outstandingFees': outstandingFees,
      'pendingComplaints': pendingComplaints,
    };
  }
}
