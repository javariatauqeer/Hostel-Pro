enum UserRole { student, admin }

enum AllocationStatus { pending, approved, rejected, cancelled }
enum ComplaintStatus { pending, inProgress, resolved }
enum FeeStatus { paid, pending, overdue }
enum RoomType { single, double, triple }
enum AnnouncementPriority { low, medium, high }

class HostelUser {
  HostelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.department,
    this.semester,
    this.studentId,
    this.roomNumber,
    this.bedNumber,
    this.hostelName,
    this.emergencyContact,
    this.allocStatus = AllocationStatus.pending,
    this.balance = 0.0,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? phone;
  final String? department;
  final int? semester;
  final String? studentId;
  final String? roomNumber;
  final String? bedNumber;
  final String? hostelName;
  final String? emergencyContact;
  final AllocationStatus allocStatus;
  final double balance;

  bool get isAdmin => role == UserRole.admin;
  bool get isStudent => role == UserRole.student;

  HostelUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? phone,
    String? department,
    int? semester,
    String? studentId,
    String? roomNumber,
    String? bedNumber,
    String? hostelName,
    String? emergencyContact,
    AllocationStatus? allocStatus,
    double? balance,
  }) {
    return HostelUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      studentId: studentId ?? this.studentId,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      hostelName: hostelName ?? this.hostelName,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      allocStatus: allocStatus ?? this.allocStatus,
      balance: balance ?? this.balance,
    );
  }
}

class Room {
  Room({
    required this.id,
    required this.roomNumber,
    required this.type,
    required this.totalCapacity,
    required this.occupiedBeds,
    required this.hostelFee,
    required this.facilities,
    required this.floor,
  });

  final String id;
  final String roomNumber;
  final RoomType type;
  final int totalCapacity;
  final int occupiedBeds;
  final double hostelFee;
  final List<String> facilities;
  final String floor;

  int get availableBeds => totalCapacity - occupiedBeds;
  bool get isAvailable => availableBeds > 0;
}

class RoomRequest {
  RoomRequest({
    required this.id,
    required this.studentId,
    required this.roomNumber,
    required this.requestedRoomType,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String studentId;
  final String roomNumber;
  final RoomType requestedRoomType;
  final AllocationStatus status;
  final DateTime createdAt;
}

class FeeRecord {
  FeeRecord({
    required this.id,
    required this.studentId,
    required this.month,
    required this.total,
    required this.paid,
    required this.dueDate,
    required this.status,
    required this.reference,
  });

  final String id;
  final String studentId;
  final String month;
  final double total;
  final double paid;
  final DateTime dueDate;
  final FeeStatus status;
  final String reference;

  double get balance => total - paid;
}

class Complaint {
  Complaint({
    required this.id,
    required this.studentId,
    required this.category,
    required this.description,
    required this.submittedAt,
    required this.status,
    this.assignedStaff,
    this.resolutionNote,
  });

  final String id;
  final String studentId;
  final String category;
  final String description;
  final DateTime submittedAt;
  final ComplaintStatus status;
  final String? assignedStaff;
  final String? resolutionNote;
}

class Announcement {
  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.priority,
    required this.category,
  });

  final String id;
  final String title;
  final String message;
  final DateTime date;
  final AnnouncementPriority priority;
  final String category;
}

class VisitorLog {
  VisitorLog({
    required this.id,
    required this.name,
    required this.studentName,
    required this.purpose,
    required this.time,
    required this.status,
  });

  final String id;
  final String name;
  final String studentName;
  final String purpose;
  final DateTime time;
  final String status;
}

class LeaveRequest {
  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  final String id;
  final String studentId;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final AllocationStatus status;
}

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
}
