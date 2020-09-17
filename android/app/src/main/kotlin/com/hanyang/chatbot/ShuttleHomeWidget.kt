package com.hanyang.chatbot

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import com.hanyang.chatbot.R.*


public class ShuttleHomeWidget : AppWidgetProvider(){
    override fun onUpdate(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?) {
        for (appWidgetId in appWidgetIds!!){
            updateShuttleWidget(context!!, appWidgetManager!!, appWidgetId)
        }
    }
    private fun updateShuttleWidget(context: Context, appWidgetManager: AppWidgetManager,
                                appWidgetId: Int) {

        // Construct the RemoteViews object
        val views = RemoteViews(context.packageName, layout.shuttle_home_widget)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

}