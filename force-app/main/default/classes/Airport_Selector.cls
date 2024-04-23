public with sharing class Airport_Selector {
    
    public static List<Airport__c> getAllAirports(){
        return [SELECT Id,Name FROM Airport__c];
    }

    public static List<Airport__c> getAirportsFromSet( Set<String> sAirportId){
        return [SELECT Id, Name, Location__Latitude__s, Location__Longitude__s FROM Airport__c where Id IN: sAirportId];
    }

}