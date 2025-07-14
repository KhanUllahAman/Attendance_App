import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

class MyCorrectionRequestListController extends NetworkManager{
  final List<Map<String, dynamic>> requests = [
      {
        'date': '2025-07-10',
        'type': 'missed_check_in',
        'checkIn': '09:00 AM',
        'checkOut': null,
        'status': 'Pending',
        'remarks': '',
        'originalIn': '—',
        'originalOut': '05:00 PM',
        'reason': 'Forgot to check in',
        'managerRemarks': '',
        'submittedOn': '2025-07-11 09:30 AM',
      },
      {
        'date': '2025-07-09',
        'type': 'wrong_time',
        'checkIn': '10:00 AM',
        'checkOut': '05:30 PM',
        'status': 'Approved',
        'remarks': 'Approved by Manager',
        'originalIn': '09:00 AM',
        'originalOut': '06:00 PM',
        'reason': 'Incorrect time recorded',
        'managerRemarks': 'Approved, next time be on time',
        'submittedOn': '2025-07-10 08:30 AM',
      },
    ];
}