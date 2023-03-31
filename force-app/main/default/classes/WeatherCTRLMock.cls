@isTest
global class WeatherCTRLMock implements HTTPCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {

        HTTPResponse response = new HTTPResponse(); 
        response.setBody('{"coord":{"lon":-73.9967,"lat":40.7484},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":276.17,"feels_like":274.15,"temp_min":271.21,"temp_max":277.71,"pressure":1027,"humidity":45},"visibility":10000,"wind":{"speed":2.06,"deg":270},"clouds":{"all":0},"dt":1680254236,"sys":{"type":2,"id":2003558,"country":"US","sunrise":1680259286,"sunset":1680304721},"timezone":-14400,"id":0,"name":"New York","cod":200}');
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
    
        return response;
    }
}