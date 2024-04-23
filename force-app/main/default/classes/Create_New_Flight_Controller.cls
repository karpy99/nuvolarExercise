public with sharing class Create_New_Flight_Controller {

    @AuraEnabled
    public static List<Airport__c> getAllAirports() {
        return Airport_Selector.getAllAirports();
    }


    @AuraEnabled 
    public static Flight__c createNewFlight(String departureAirportId, String arrivalAirportId) {
        try{
            Set<String> sAirportId = new Set<String>{departureAirportId, arrivalAirportId};
            List<Airport__c> lAirports = Airport_Selector.getAirportsFromSet(sAirportId);
            if(lAirports.size()>= 2){
                Decimal flightDistance = calculateDistance(lAirports[0]?.Location__Latitude__s,lAirports[0]?.Location__Longitude__s, lAirports[1]?.Location__Latitude__s,lAirports[1]?.Location__Longitude__s);
                if(flightDistance <= 0){
                    throw new Create_New_Flight_Controller_Exception();
                }else{
                    Flight__c newFlight = new Flight__c();
                    newFlight.Departure_Airport__c = departureAirportId;
                    newFlight.Arrival_Airport__c = arrivalAirportId;
                    newFlight.Distance__c = flightDistance;
                    insert newFlight; 
                    List<Flight__c> lNewFlight = FLight_Selector.getFlightFromSet(new Set<String>{newFlight.Id});
                    return lNewFlight[0];
                }
                
            }else {
                return null;
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }


    private static Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        try {
         
            Integer earthRadius = 6371 * 1000; // in meters
            // Transform coordinates from degrees to radians
            Decimal latitudeRadians1 = latitude1 * Math.PI/180;
            Decimal latitudeRadians2 = latitude2 * Math.PI/180;
            // Latitude and longitude differences in radians
            Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
            Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
            Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
            Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
            Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
            Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            Decimal distance = earthRadius * arc; // in metres
            return distance;
        
        }catch(Exception e) {
            System.debug(e.getMessage());
            return -1;
        }
    }

    public class Create_New_Flight_Controller_Exception extends Exception {}
    
}