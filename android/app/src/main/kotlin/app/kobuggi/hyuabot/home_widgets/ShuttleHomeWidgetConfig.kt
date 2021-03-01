package app.kobuggi.hyuabot.home_widgets

import android.Manifest
import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.RadioGroup
import android.widget.RemoteViews
import android.widget.SeekBar
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import app.kobuggi.hyuabot.AppLocationListener
import app.kobuggi.hyuabot.MainActivity
import app.kobuggi.hyuabot.R

class ShuttleHomeWidgetConfig : Activity (){
    val SHARED_PRES = "prefs"
    val SHUTTLE_STOP = "shuttle_stop"
    val SHUTTLE_DIRECTION = "shuttle_direction"

    private var appWidgetID : Int = AppWidgetManager.INVALID_APPWIDGET_ID;
    private lateinit var radioGroup : RadioGroup
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
            R.id.shuttleStopDormitory -> selectedValue = "dorm"
            R.id.shuttleStopOutSchool -> selectedValue = "outSchool"
            R.id.shuttleStopStation -> selectedValue = "station"
            R.id.shuttleStopTerminal -> selectedValue = "terminal"
            R.id.shuttleStopInSchool -> selectedValue = "inSchool"
        }
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED){
            return
        }

        var stopName : String = this.getString(this.resources.getIdentifier(selectedValue, "string", this.packageName))
        var directionCode : String = when(selectedValue){
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