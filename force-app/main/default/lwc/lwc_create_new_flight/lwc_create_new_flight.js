import { LightningElement,  wire, api, track } from 'lwc';
import Toast from 'lightning/toast';

import getAllAirports from '@salesforce/apex/Create_New_Flight_Controller.getAllAirports';
import createNewFlight from '@salesforce/apex/Create_New_Flight_Controller.createNewFlight';


export default class Lwc_create_new_flight extends LightningElement {


    @track departureAirport = '';
    @track arrivalAirport = '';
    @track lDepartureAirports = [];
    @track lArrivalAirports = [];
    @track flightDistance = '';
    @track flightDeparture = '';
    @track flightArrival = '';
    @track isFlightCreated = false;

    connectedCallback(){
        getAllAirports()
        .then(result => {
            var allAirports = [];
            for (var i = 0; i < result.length; i++) {
                allAirports.push({label: result[i].Name, value: result[i].Id});
            }
            this.lArrivalAirports = allAirports;
            this.lDepartureAirports = allAirports;

        })
        .catch(error => {
            Toast.show({
                label: 'An error has occurred while loading Airports'
            });
        });
    }


    handleDepartureAirport(event){
        
        console.log('event:',JSON.stringify(event.target.label)  );
        this.departureAirport = event.target.value;
    }

    handleArrivalAirport(event){
        this.arrivalAirport = event.target.value;
    }
    async handleCreateFlight(){
        try {
            let result = await createNewFlight({ departureAirportId: this.departureAirport, arrivalAirportId:  this.arrivalAirport});
            if(result == null){
                Toast.show({
                    label: 'An error has occurred while creating the flight'
                });
            }else{
                this.flightDistance = result.Distance__c;
                this.flightDeparture = result.Departure_Airport__r.Name;
                this.flightArrival = result.Arrival_Airport__r.Name;
                this.isFlightCreated = true;
            }
        } catch (error) {
            Toast.show({
                label: 'An error has occurred while creating the flight'
            });
        }
    }
}