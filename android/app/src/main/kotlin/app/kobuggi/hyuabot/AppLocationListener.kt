package app.kobuggi.hyuabot

import android.Manifest
import android.content.Context
import android.content.Context.LOCATION_SERVICE
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.core.content.ContextCompat


class AppLocationListener : LocationListener {
    var latitude = 0.0
    var ctx: Context? = null
    var location: Location? = null
    var locationManager: LocationManager? = null
    var isGPSEnabled = false
    var isNetworkEnabled = false
    var longitude = 0.0
    constructor(ctx: Context) {
        this.ctx = ctx
        try {
            locationManager = ctx.getSystemService(LOCATION_SERVICE) as LocationManager
            isGPSEnabled = locationManager!!.isProviderEnabled(LocationManager.GPS_PROVIDER)
            Toast.makeText(ctx, "GPS Enable $isGPSEnabled", Toast.LENGTH_LONG).show()
            isNetworkEnabled = locationManager!!.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
            Toast.makeText(ctx, "Network Enable $isNetworkEnabled", Toast.LENGTH_LONG).show()
            if (Build.VERSION.SDK_INT >= 23 && (ContextCompat.checkSelfPermission(ctx, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) && ContextCompat.checkSelfPermission(ctx, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            }
            if (isGPSEnabled == true) {
                locationManager!!.requestLocationUpdates(
                        LocationManager.GPS_PROVIDER, 0, 0 as Float, this)
                location = locationManager!!.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            }
            if (isNetworkEnabled == true) {
                locationManager!!.requestLocationUpdates(
                        LocationManager.NETWORK_PROVIDER, 0, 0 as Float, this)
                location = locationManager!!.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
            }
            latitude = location!!.latitude
            longitude = location!!.longitude
            // Toast.makeText(ctx,"latitude: "+latitude+" longitude: "+longitude,Toast.LENGTH_LONG).show();
        } catch (ex: Exception) {
            Toast.makeText(ctx, "Exception $ex", Toast.LENGTH_LONG).show()
        }
    }

    @Nullable
    override fun onLocationChanged(loc: Location) {
        latitude = loc.latitude
        longitude = loc.longitude
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
}