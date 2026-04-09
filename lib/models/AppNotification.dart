class AppNotification {

  final String title;
  final String type;
  final String message;
  final DateTime timeStamp;
  final bool isRead;

  AppNotification({required this.title, required this.type, required this.message, required this.timeStamp, required this.isRead});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'], 
      type: json['type'], 
      message: json['message'], 
      timeStamp: json['created_at'],
      isRead: json['is_read']
    );
  }

  
}