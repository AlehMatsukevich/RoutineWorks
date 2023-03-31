import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import fetchWeatherInfo from "@salesforce/apex/WeatherCtrl.fetchWeatherInfo";

import NAME from '@salesforce/schema/Account.Name';
import BILLING_CITY from '@salesforce/schema/Account.BillingCity';

export default class AccountWeather extends LightningElement {

    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: [NAME, BILLING_CITY] })
    account;
    
    result = {};
    
    get name() {
        return getFieldValue(this.account.data, NAME);
    }
    
    get city() {
        return getFieldValue(this.account.data, BILLING_CITY);
    }
    
    connectedCallback() {
       fetchWeatherInfo({recordId : this.recordId})
        .then(result => {

            console.log(result.name);
            result.temp = (result.temp - 274.15).toFixed(2);
            result.sunset = this.convertUnixToTime(result.sunset);
            result.sunrise = this.convertUnixToTime(result.sunrise);

            this.result = result;

            this.handleSpinner();
        })
        .catch((error) => {
            const evt = new ShowToastEvent({
                title: "Шо та пашло нетак!",
                message: error.body.message,
                variant: "error",
            });
            this.dispatchEvent(evt);
            this.handleSpinner();
        })
    }   
 
    convertUnixToTime(unixtimestamp){
        console.log('unixtimestamp');
        console.log(unixtimestamp);
        let dt = unixtimestamp * 1000;
        let myDate = new Date(dt);
        console.log('myDate');
        console.log(myDate);
        return(myDate.toLocaleString());
    }
 
    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }
   
}