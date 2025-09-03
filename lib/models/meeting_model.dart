class MeetingModel {
  final int status;
  final String message;
  final List<Payload> payload;

  MeetingModel({
    required this.status,
    required this.message,
    this.payload = const [],
  });

  MeetingModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int? ?? 0,
        message = json['message'] as String? ?? '',
        payload = (json['payload'] as List<dynamic>?)
                ?.map((v) => Payload.fromJson(v as Map<String, dynamic>))
                .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload.map((v) => v.toJson()).toList(),
    };
  }
}

class Payload {
  final int meetingInstanceId;
  final int meetingId;
  final String instanceDate;
  final String startTime;
  final String endTime;
  final String status;
  final String title;
  final String recurrenceRule;
  final String recurrenceType;
  final String recurrenceStartDate;
  final String recurrenceEndDate;
  final String locationType;
  final String locationDetails;
  final String agenda;
  final String hostName;
  final String attendees;
  final String? minutes;

  Payload({
    required this.meetingInstanceId,
    required this.meetingId,
    required this.instanceDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.title,
    required this.recurrenceRule,
    required this.recurrenceType,
    required this.recurrenceStartDate,
    required this.recurrenceEndDate,
    required this.locationType,
    required this.locationDetails,
    required this.agenda,
    required this.hostName,
    required this.attendees,
    this.minutes,
  });

  Payload.fromJson(Map<String, dynamic> json)
      : meetingInstanceId = json['meeting_instance_id'] as int? ?? 0,
        meetingId = json['meeting_id'] as int? ?? 0,
        instanceDate = json['instance_date'] as String? ?? '',
        startTime = json['start_time'] as String? ?? '',
        endTime = json['end_time'] as String? ?? '',
        status = json['status'] as String? ?? '',
        title = json['title'] as String? ?? '',
        recurrenceRule = json['recurrence_rule'] as String? ?? '',
        recurrenceType = json['recurrence_type'] as String? ?? '',
        recurrenceStartDate = json['recurrence_start_date'] as String? ?? '',
        recurrenceEndDate = json['recurrence_end_date'] as String? ?? '',
        locationType = json['location_type'] as String? ?? '',
        locationDetails = json['location_details'] as String? ?? '',
        agenda = json['agenda'] as String? ?? '',
        hostName = json['host_name'] as String? ?? '',
        attendees = json['attendees'] as String? ?? '',
        minutes = json['minutes'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'meeting_instance_id': meetingInstanceId,
      'meeting_id': meetingId,
      'instance_date': instanceDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'title': title,
      'recurrence_rule': recurrenceRule,
      'recurrence_type': recurrenceType,
      'recurrence_start_date': recurrenceStartDate,
      'recurrence_end_date': recurrenceEndDate,
      'location_type': locationType,
      'location_details': locationDetails,
      'agenda': agenda,
      'host_name': hostName,
      'attendees': attendees,
      'minutes': minutes,
    };
  }
}