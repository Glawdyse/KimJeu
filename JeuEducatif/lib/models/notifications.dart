class NotificationModel {
  final int idNotif;
  final String typeNotif;
  final String dateNotif;
  final String userName;
  final String message;

  NotificationModel({
    required this.idNotif,
    required this.typeNotif,
    required this.dateNotif,
    required this.userName,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      idNotif: json['id'] ?? 0,
      typeNotif: json['typeNotif'] ?? '',
      dateNotif: json['dateNotif'] ?? '',
      userName: json['user']?['nomPrenom'] ?? 'Inconnu',
      message: json['message'] ?? 'Nouveau jeu créé',
    );
  }
}
