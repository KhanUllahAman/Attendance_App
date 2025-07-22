// request_type_enum.dart
enum RequestType {
  missedCheckIn,
  missedCheckOut,
  wrongTime,
  both;

  String get displayName {
    switch (this) {
      case RequestType.missedCheckIn:
        return "Missed Check-In";
      case RequestType.missedCheckOut:
        return "Missed Check-Out";
      case RequestType.wrongTime:
        return "Wrong Time";
      case RequestType.both:
        return "Both Check-In/Out";
    }
  }

  String get apiValue {
    switch (this) {
      case RequestType.missedCheckIn:
        return "missed_check_in";
      case RequestType.missedCheckOut:
        return "missed_check_out";
      case RequestType.wrongTime:
        return "wrong_time";
      case RequestType.both:
        return "both";
    }
  }

  bool get requiresCheckIn => this == RequestType.missedCheckIn || 
                            this == RequestType.wrongTime || 
                            this == RequestType.both;

  bool get requiresCheckOut => this == RequestType.missedCheckOut || 
                             this == RequestType.wrongTime || 
                             this == RequestType.both;

  static RequestType? fromApiValue(String value) {
    for (var type in RequestType.values) {
      if (type.apiValue == value) {
        return type;
      }
    }
    return null;
  }
}