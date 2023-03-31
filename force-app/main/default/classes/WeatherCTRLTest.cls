@isTest
public with sharing class WeatherCTRLTest {
    @isTest
    private static void fetchWeatherInfo() {
        Account acc = new Account();
        acc.Name ='testName'; 
        acc.BillingCity = 'New York';
        acc.BillingPostalCode ='10001';
        acc.BillingCountry ='US';

        insert acc;

        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new WeatherCTRLMock());
        
        WeatherCTRL.wrapperData response = WeatherCTRL.fetchWeatherInfo(acc.Id);
        Test.stopTest();
        System.assertEquals('New York', response.name);
        System.assertEquals(45 , response.humidity);
    }

}