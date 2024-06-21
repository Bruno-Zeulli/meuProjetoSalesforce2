public without sharing class CustomNotificationHandler {
    public static void notifyUser(
        String recipientId,
        String targetId,
        String title,
        String message
    ) {
        notifyUsers(new Set<String>{ recipientId }, targetId, title, message);
    }

    public static void notifyUsers(
        Set<String> recipientsIds,
        String targetId,
        String title,
        String message
    ) {
        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'SendNotificationNewsFeedItems'
        ];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        notification.setTitle(title);
        notification.setBody(message);

        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        try {
            notification.send(recipientsIds);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}