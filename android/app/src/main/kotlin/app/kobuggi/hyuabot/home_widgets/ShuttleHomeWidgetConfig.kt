package app.kobuggi.hyuabot.home_widgets

import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.RadioGroup
import android.widget.RemoteViews
import android.widget.SeekBar
import app.kobuggi.hyuabot.MainActivity
import app.kobuggi.hyuabot.R

class ShuttleHomeWidgetConfig : Activity (){
    val SHARED_PRES = "prefs"
    val SHUTTLE_STOP = "auto"

    private var appWidgetID : Int = AppWidgetManager.INVALID_APPWIDGET_ID;
    private lateinit var radioGroup : RadioGroup
    private lateinit var widgetTransparent : SeekBar
    private var selectedValue : String = "auto"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.shuttle_widget_config)

        val configIntent : Intent = intent
        val extras : Bundle? = configIntent.extras
        if(extras != null){
            appWidgetID = extras.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
        }

        val resultIntent = Intent()
        resultIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetID)
        setResult(RESULT_OK, resultIntent)

        if(appWidgetID == AppWidgetManager.INVALID_APPWIDGET_ID){
            finish()
        }

        radioGroup = findViewById(R.id.shuttleRadioGroup)
        widgetTransparent = findViewById(R.id.shuttleWidgetTransparent)
    }

    fun confirmConfiguration(view : View){
        val appWidgetManager : AppWidgetManager = AppWidgetManager.getInstance(this)
        val intent : Intent = Intent(this, MainActivity::class.java)
        val pendingIntent : PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)

        val transparent : Int = widgetTransparent.progress
        val stop : Int = radioGroup.checkedRadioButtonId

        val views : RemoteViews = RemoteViews(this.packageName, R.layout.shuttle_widget)
        views.setOnClickPendingIntent(R.id.button, pendingIntent)
        when(stop){
            R.id.shuttleStopAuto -> selectedValue = "auto"
            R.id.shuttleStopDormitory -> selectedValue = "dorm"
            R.id.shuttleStopOutSchool -> selectedValue = "outSchool"
            R.id.shuttleStopStation -> selectedValue = "station"
            R.id.shuttleStopTerminal -> selectedValue = "terminal"
            R.id.shuttleStopInSchool -> selectedValue = "inSchool"
        }
        val opacity = transparent / 100
        val backgroundColor = 0xffffff //background color (here black)
        views.setInt(R.id.shuttleWidget, "setBackgroundColor", (opacity * 0xFF) shl 24 or backgroundColor)
        appWidgetManager.updateAppWidget(appWidgetID, views)

        val prefs = getSharedPreferences(SHARED_PRES, MODE_PRIVATE)
        val editor = prefs.edit()
        editor.putString(SHUTTLE_STOP + appWidgetID, selectedValue)
        editor.apply()

        val resultIntent = Intent()
        resultIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetID)
        setResult(RESULT_OK, resultIntent)

        finish()
    }
}