결론

> ****UNNotificationServiceExtension 를 Target으로 추가하고**** didReceive(_:withContentHandler:)  내에서 푸시 노티피케이션을 커스텀 할 수 있다.
> 

# ****UNNotificationServiceExtension****

> An object that modifies the content of a remote notification before it’s delivered to the user.
> 

→ 사용자에게 전달되기 전에, remote notification 의 컨텐츠를 수정할 수 있도록 도와주는 객체입니다.

- 이 객체는 사용자에게 전달하기 전에 컨텐츠를 수정할 수 있도록 도와줍니다.
- 이 객체 자체에서 UI를 보여주거나 하지는 않습니다. 다만, 특정 유형에 대해서 알림을 전달할 때, 그에 맞게 사용자 디바이스에 보여주기 위해 동작합니다.
- 구체적인 예시로, 암호화된 데이터가 있다면, 해당 데이터를 해독하거나 알림과 관련된 이미지를 다운로드 할 수 있도록 도와줍니다.
- 이 객체를 사용하기 위해서 생성하거나 할 필요는 없습니다. Xcode template에서 Target을 추가하는 방식으로 구현합니다.
- 커스텀 하고 싶다면, `didReceive(_:witContentHandler)` 메소드 내에서 구현하면 됩니다.

## didReceive(_:withContentHandler:)

- 해당 메소드를 사용하기 위한 조건)
    - 앱이 Remote Notification에 대한 알림을 받을 수 있도록 구현된 상태여야 합니다.
    - 알림에는 `mutable-content` 값이 1 로 세팅되어 있어야 해당 메소드가 호출됩니다.

- 이 메소드를 사용하여, 알림을 변경할 수 있습니다만, 메소드에서 작업을 수행하는데 제한된 시간이 있습니다.
- 제한된 시간 내에 완료하지 못하게 된다면, `serviceExtensionTimeWillExpire()` 메소드를 시스템에서 호출합니다.
- 위 메소드는 변경하고 싶은 사항에 대한 마지막 처리를 할 수 있는 마지막 기회입니다.
- 만약 제한된 시간 내에 처리하지 못한 콘텐츠에 대해서 처리하고 싶은 것이 없다면, 그냥 두면 본래 콘텐츠만 보여주게 됩니다.(커스텀되지 않은 컨텐츠만 보여준다는 뜻)

## 구현

1. Xcode에 NotificationServiceExtension 을 추가한다
    - [https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications](https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications)
    - [https://rhammer.tistory.com/270](https://rhammer.tistory.com/270)
    - NotificationServiceExtension Target을 추가하고 `Frameworks and Libraries` 에 FirebaseMessaging이 추가된지 확인할 것(FCM 이용 하는 경우)
        
    ![image](https://user-images.githubusercontent.com/65879950/161218792-b2288783-b67f-4dd4-b67b-48d2102362e0.png)

        
    
2. 사용자 정의 이름으로 구성된 `UNNotificationServiceExtension` 을 따르는 객체에 코드를 작성한다.
    
    (아래 코드는 Firebase FCM 기준입니다.)
    
    ```swift
    import UserNotifications
    import FirebaseMessaging
    
    class NotificationService: UNNotificationServiceExtension {
    
        var contentHandler: ((UNNotificationContent) -> Void)?
        var bestAttemptContent: UNMutableNotificationContent?
    
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
            guard let bestAttemptContent = bestAttemptContent else { return }
    
    				/* title과 body 커스텀 */
            bestAttemptContent.title = "[Modified]" + bestAttemptContent.title
            bestAttemptContent.body = "[Modified]" + bestAttemptContent.body
    
            FIRMessagingExtensionHelper().populateNotificationContent(
                bestAttemptContent,
                withContentHandler: contentHandler)
        }
    
        
        override func serviceExtensionTimeWillExpire() {
            // Called just before the extension will be terminated by the system.
            // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
            if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
                contentHandler(bestAttemptContent)
            }
        }
    }
    ```
