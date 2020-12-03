package app.kobuggi.hyuabot

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class BackgroundFirebaseMessagingService : FirebaseMessagingService(){
    override fun onMessageReceived(msg: RemoteMessage) {
        if(msg.data.containsKey("name") && msg.data.containsKey("type")){
            if (msg.data["type"] == "reading_room"){
                sendLibraryNotification("휴아봇", msg.data["name"]!!)
            }
        }
    }

    private fun sendLibraryNotification(title: String?, body: String){
        val builder = getNotificationBuilder("hyuabot_library", "학술정보관 열람실 알림")
        builder.setSmallIcon(R.mipmap.launcher_icon)
        val bitmap = BitmapFactory.decodeResource(resources, R.mipmap.launcher_icon)
        builder.setLargeIcon(bitmap)
        builder.setAutoCancel(true)
        builder.setContentTitle(title)
        builder.setContentText(body)
        FirebaseMessaging.getInstance().unsubscribeFromTopic(body)
        (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).notify(10, builder.build())

    }

    private fun getNotificationBuilder(id: String, name: String) : NotificationCompat.Builder {
        val builder: NotificationCompat.Builder?

        builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { // 8.0 오레오 버전
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(id, name, NotificationManager.IMPORTANCE_DEFAULT)// 중요도에 따라 메시지가 보이는 순서가 달라진다.
            channel.enableLights(true) //
            channel.enableVibration(true)
            manager.createNotificationChannel(channel)
            NotificationCompat.Builder(this, id)
        } else { // 그 외의 버전s
            NotificationCompat.Builder(this, "")
        }

        return builder
    }
}