using Toybox.WatchUi as Ui;
using Toybox.UserProfile as Up;

class larsTRIMPView extends Ui.SimpleDataField {

	//all are maxes except zone2 which is a min for zone 2 
    var HRZONE1 = 100;
    var HRZONE2 = 120;
    var HRZONE3 = 134;
    var HRZONE4 = 139;
    var HRZONE5 = 154;
    
    var impact1 = 1;
    var impact2 = 2;
    var impact3 = 3;
    var impact4 = 4;
    var impact5 = 5;
    
    var callCount = 0;
    var trimpTotal = 0.0;
    
    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "TRIMP";
        
        //get users HR zones
		var profile = Up.getProfile();
		var sport = Up.getCurrentSport();
		var HRZones = profile.getHeartRateZones(sport);
		if (HRZones == null) {
			System.println("HRZones not populated, using defaults");
		}
		
		HRZONE1 = HRZones[0];	
		HRZONE2 = HRZones[1];	
		HRZONE3 = HRZones[2];	
		HRZONE4 = HRZones[3];	
		HRZONE5 = HRZones[4];	
		
		System.println("HR Zones 2-5 for " + sport + ": " + HRZONE2 + " / " + HRZONE3 + " / " + HRZONE4 + " / " + HRZONE5);
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.

		//System.println("HR: " + info.currentHeartRate);        

		if (info.currentHeartRate == null ) {
			return null;
		}
		var hr = info.currentHeartRate;       
       	var impact = 0.0; 
       	
        if (hr >= HRZONE5) {
        	impact = impact5;
        } else if (hr > HRZONE4) {
        	impact = impact4;
        } else if (hr > HRZONE3) {
        	impact = impact3;
        } else if (hr > HRZONE2) {
        	impact = impact2;
        } else if (hr > HRZONE1) {
        	impact = impact1;
        }

		//System.println("impact: " + impact + ";" + impact/60);
		
		var trimpTot = calcTrimp(impact/60.0);	//compute is called every min; trimp calc is aggregated by the minute
		
		var elapsed = info.timerTime / 1000.0; 
       	var trimpPerHr = 0.0;
		if ( elapsed > 60 ) {
       		trimpPerHr = trimpTot / (elapsed / 3600.0 );
       	}
       	
       	var returnStr = formatStr(trimpTot) + "/" + formatStr(trimpPerHr); 
        return returnStr;
    }
    
    function calcTrimp(imp) {
		//System.println("imp: " + imp);
		trimpTotal += imp;    
		//System.println("trimpTotal: " + trimpTotal);
		return trimpTotal;
    }
    
    function formatStr(s) {
   		return s.format("%1d"); 
   		//return s.format("%.1f"); 
    }
}