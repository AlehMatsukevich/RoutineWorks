public with sharing class WeatherCTRL {
    @AuraEnabled
    public static wrapperData fetchWeatherInfo(Id recordId) {
        Account acc = [SELECT Id, Name, BillingCountry, BillingPostalCode FROM Account WHERE Id = :recordId LIMIT 1];
        System.debug('zipCode ' + acc.BillingPostalCode);
        System.debug('countryCode ' + acc.BillingCountry);
        String APIKey = 'e1c5ba3148427a868b0b37fa6ba88091';
        //String endPoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + '&units=metric&appid=' +appId;
        //String endPoint = 'https://api.openweathermap.org/data/2.5/weather?lat=' + 44.34 + '&lon=' + 10.99 +'&appid='+ +APIKey;
    
        String endPoint = 'https://api.openweathermap.org/data/2.5/weather?zip=' + acc.BillingPostalCode + ',' + acc.BillingCountry +'&appid=' +APIKey;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        response = http.send(request);
        if (response.getStatusCode() == 200) {
            String jsonResponse = response.getBody();
            System.debug('getBody ' + jsonResponse);
            fromJSON jsonParseData = (fromJSON)parse(jsonResponse);
            System.debug('jsonParseData ' + jsonParseData);
            wrapperData wrpData = new wrapperData(jsonParseData);
            System.debug('WRP' + wrpData);
            return wrpData;
        } else{
            throw newMessageException('Error : Please check zipcode or country');
        }
    }
 
    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
 
    public class wrapperData{
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Double temp;
        @AuraEnabled
        public Integer sunset;
        @AuraEnabled
        public Integer sunrise;
        @AuraEnabled
        public Integer humidity;
        @AuraEnabled
        public Integer pressure;
        
        public wrapperData(fromJSON parseData){
            cls_main te = parseData.main;
            this.name = parseData.name;
            this.temp = te.temp;
            this.humidity = te.humidity;
            this.pressure = te.pressure;
            this.sunrise = parseData.sys.sunrise;
            this.sunset = parseData.sys.sunset;
        }
    }
 
    public class fromJSON{
        public cls_coord coord;
        public cls_weather[] weather;
        public String base;
        public cls_main main;
        public Integer visibility;  
        public cls_wind wind;
        public cls_clouds clouds;
        public Integer dt;  
        public cls_sys sys;
        public Integer timezone;    
        public Integer id;  
        public String name; 
        public Integer cod; 
    }
    public class cls_coord {
        public Double lon; 
        public Double lat;  
    }
    public class cls_weather {
        public Integer id; 
        public String main; 
        public String description;  
        public String icon; 
    }
    public class cls_main {
        public Double temp; 
        public Double feels_like;   
        public Double temp_min; 
        public Double temp_max; 
        public Integer pressure;   
        public Integer humidity;    
    }
    public class cls_wind {
        public Double speed;   
        public Integer deg; 
        public Double gust; 
    }
    public class cls_clouds {
        public Integer all;
    }
    public class cls_sys {
        public Integer type; 
        public Integer id;  
        public String country; 
        public Integer sunrise; 
        public Integer sunset; 
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }
}