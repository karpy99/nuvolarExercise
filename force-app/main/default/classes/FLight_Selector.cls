public with sharing class FLight_Selector {
    

    public static List<Flight__c> getFlightFromSet( Set<String> sFlightId){
        return [SELECT Id, Departure_Airport__c,Departure_Airport__r.Name, Arrival_Airport__r.Name,  Arrival_Airport__c, Distance__c FROM Flight__c WHERE Id IN: sFlightId];
    }
}