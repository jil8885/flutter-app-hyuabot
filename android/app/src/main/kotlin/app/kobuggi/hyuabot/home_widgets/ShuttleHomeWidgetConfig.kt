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
    val SHUTTLE_STOP = "shuttle_stop"
    val SHUTTLE_DIRECTION = "shuttle_direction"

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
//        widgetTransparent = findViewById(R.id.shuttleWidgetTransparent)
    }

    fun confirmConfiguration(view : View){
        val appWidgetManager : AppWidgetManager = AppWidgetManager.getInstance(this)
        val intent : Intent = Intent(this, MainActivity::class.java)
        val pendingIntent : PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)

        val stop : Int = radioGroup.checkedRadioButtonId

        val views : RemoteViews = RemoteViews(this.packageName, R.layout.shuttle_widget)
        views.setOnClickPendingIntent(R.id.shuttleStop, pendingIntent)
        views.setOnClickPendingIntent(R.id.shuttleDirection, pendingIntent)
        when(stop){
            R.id.shuttleStopAuto -> selectedValue = "auto"
            R.id.shuttleStopDormitory -> selectedValue = "dorm"
            R.id.shuttleStopOutSchool -> selectedValue = "outSchool"
            R.id.shuttleStopStation -> selectedValue = "station"
            R.id.shuttleStopTerminal -> selectedValue = "terminal"
            R.id.shuttleStopInSchool -> selectedValue = "inSchool"
        }

        var directionCode : String = ""
        var stopName : String
        val stopList = listOf("dorm", "outSchool", "station", "terminal")
        val latitudeList = listOf(37.293504675319404, 37.29875067621797, 37.3078222739517, 37.31925490540365)
        val longitudeList = listOf(126.83652294056917, 126.83795526758001, 126.85385203121884, 126.84558571149732)
        var distance = 9999999
        if(selectedValue == "auto"){
            for (i in 0..3){

            }
            stopName = "outSchool"
        } else {
            stopName = this.getString(this.resources.getIdentifier(selectedValue, "string", this.packageName))
        }

        directionCode = when(selectedValue){
            "dorm" -> "bound_for_all"
            "outSchool" -> "bound_for_all"
            "station" -> "bound_for_school"
            "terminal" -> "bound_for_school"
            "inSchool" -> "bound_for_school"
            else -> "bound_for_all"
        }

        val directionName = this.getString(this.resources.getIdentifier(directionCode, "string", this.packageName))
        views.setCharSequence(R.id.shuttleStop, "setText", stopName)
        views.setCharSequence(R.id.shuttleDirection, "setText", directionName)
        appWidgetManager.updateAppWidget(appWidgetID, views)

        val prefs = getSharedPreferences(SHARED_PRES, MODE_PRIVATE)
        val editor = prefs.edit()
        editor.putString(SHUTTLE_STOP + appWidgetID, selectedValue)
        editor.putString(SHUTTLE_DIRECTION + appWidgetID, directionCode)
        editor.apply()

        val resultIntent = Intent()
        resultIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetID)
        setResult(RESULT_OK, resultIntent)

        finish()
    }
}