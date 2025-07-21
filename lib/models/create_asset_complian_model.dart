// asset_enums.dart
enum AssetRequestType {
  newRequest,
  replacement,
  repair,
  returnRequest,
  issue,
  complaint;

  String get displayName {
    switch (this) {
      case AssetRequestType.newRequest:
        return "New";
      case AssetRequestType.replacement:
        return "Replacement";
      case AssetRequestType.repair:
        return "Repair";
      case AssetRequestType.returnRequest:
        return "Return";
      case AssetRequestType.issue:
        return "Issue";
      case AssetRequestType.complaint:
        return "Complaint";
    }
  }

  String get apiValue {
    switch (this) {
      case AssetRequestType.newRequest:
        return "new";
      case AssetRequestType.replacement:
        return "replacement";
      case AssetRequestType.repair:
        return "repair";
      case AssetRequestType.returnRequest:
        return "return";
      case AssetRequestType.issue:
        return "issue";
      case AssetRequestType.complaint:
        return "complaint";
    }
  }

  static AssetRequestType? fromDisplayName(String displayName) {
    for (var type in AssetRequestType.values) {
      if (type.displayName == displayName) {
        return type;
      }
    }
    return null;
  }
}

enum ComplaintCategory {
  hardware,
  software,
  network,
  officeFacility,
  other;

  String get displayName {
    switch (this) {
      case ComplaintCategory.hardware:
        return "Hardware";
      case ComplaintCategory.software:
        return "Software";
      case ComplaintCategory.network:
        return "Network";
      case ComplaintCategory.officeFacility:
        return "Office Facility";
      case ComplaintCategory.other:
        return "Other";
    }
  }

  String get apiValue {
    switch (this) {
      case ComplaintCategory.hardware:
        return "hardware";
      case ComplaintCategory.software:
        return "software";
      case ComplaintCategory.network:
        return "network";
      case ComplaintCategory.officeFacility:
        return "office_facility";
      case ComplaintCategory.other:
        return "other";
    }
  }

  static ComplaintCategory? fromDisplayName(String displayName) {
    for (var category in ComplaintCategory.values) {
      if (category.displayName == displayName) {
        return category;
      }
    }
    return null;
  }
}

enum AssetType {
  laptop,
  desktop,
  mouse,
  keyboard,
  monitor,
  printer,
  scanner,
  hardDrive,
  charger,
  projector,
  softwareInstallation,
  softwareError,
  internetIssue,
  vpnIssue,
  emailIssue,
  powerIssue,
  desk,
  chair,
  ac,
  light,
  other;

  String get displayName {
    switch (this) {
      case AssetType.laptop:
        return "Laptop";
      case AssetType.desktop:
        return "Desktop";
      case AssetType.mouse:
        return "Mouse";
      case AssetType.keyboard:
        return "Keyboard";
      case AssetType.monitor:
        return "Monitor";
      case AssetType.printer:
        return "Printer";
      case AssetType.scanner:
        return "Scanner";
      case AssetType.hardDrive:
        return "Hard Drive";
      case AssetType.charger:
        return "Charger";
      case AssetType.projector:
        return "Projector";
      case AssetType.softwareInstallation:
        return "Software Installation";
      case AssetType.softwareError:
        return "Software Error";
      case AssetType.internetIssue:
        return "Internet Issue";
      case AssetType.vpnIssue:
        return "VPN Issue";
      case AssetType.emailIssue:
        return "Email Issue";
      case AssetType.powerIssue:
        return "Power Issue";
      case AssetType.desk:
        return "Desk";
      case AssetType.chair:
        return "Chair";
      case AssetType.ac:
        return "AC";
      case AssetType.light:
        return "Light";
      case AssetType.other:
        return "Other";
    }
  }

  String get apiValue {
    switch (this) {
      case AssetType.laptop:
        return "laptop";
      case AssetType.desktop:
        return "desktop";
      case AssetType.mouse:
        return "mouse";
      case AssetType.keyboard:
        return "keyboard";
      case AssetType.monitor:
        return "monitor";
      case AssetType.printer:
        return "printer";
      case AssetType.scanner:
        return "scanner";
      case AssetType.hardDrive:
        return "hard_drive";
      case AssetType.charger:
        return "charger";
      case AssetType.projector:
        return "projector";
      case AssetType.softwareInstallation:
        return "software_installation";
      case AssetType.softwareError:
        return "software_error";
      case AssetType.internetIssue:
        return "internet_issue";
      case AssetType.vpnIssue:
        return "vpn_issue";
      case AssetType.emailIssue:
        return "email_issue";
      case AssetType.powerIssue:
        return "power_issue";
      case AssetType.desk:
        return "desk";
      case AssetType.chair:
        return "chair";
      case AssetType.ac:
        return "ac";
      case AssetType.light:
        return "light";
      case AssetType.other:
        return "other";
    }
  }

  static AssetType? fromDisplayName(String displayName) {
    for (var type in AssetType.values) {
      if (type.displayName == displayName) {
        return type;
      }
    }
    return null;
  }
}