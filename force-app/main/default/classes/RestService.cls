public with sharing class RestService {
    Id companyId = [SELECT Id FROM Company__c WHERE Name ='tratata' LIMIT 1]; //external ID
    Id accountId = [SELECT Id FROM Employee__c WHERE Name ='tratata' LIMIT 1]; //external ID

    public static List<Employee> getEmployees() {
        List<Employee> employeesList = new List<Employee>();

        HttpRequest request = new HttpRequest();
        // endpoint Employees https://secure3.saashr.com/ta/rest/v2/companies/{cid}/employees/ вроде единственный что подходит
        request.setEndpoint('https://secure3.saashr.com/ta/rest/v2/companies/' +companyid +'/employees/');
        request.setMethod('GET');

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(request);

            if (httpResponse.getStatusCode() == 200) {
                employeesList = new Employee().parseJSON(httpResponse.getBody());  
            } else {
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (Exception ex) {
            throw ex;
        }

        if (!employeesList.isEmpty()) {
            return employeesList;
        } else {
            return null;
        }
    }

    public static List<Employee> getTimeEntries() {
        List<TimeEntries> timeEntriesList = new List<TimeEntries>();

        HttpRequest request = new HttpRequest();
        // endpoint Employees -> TimeEntries https://secure3.saashr.com/ta/rest/v2/companies/{cid}/time-entries этот наверное пизже будет так как скопом по аккаунту всех должен собрать
        // endpoint Employee -> timeEntries https://secure3.saashr.com/ta/rest/v2/companies/{cid}/employees/{aid}/time-entries
        request.setEndpoint('https://secure3.saashr.com/ta/rest/v2/companies/'+ companyid +'/employees/'+ accountId +'/time-entries');
        request.setMethod('GET');

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(request);

            if (httpResponse.getStatusCode() == 200) {
                timeEntriesList = new TimeEntries().parseJSON(httpResponse.getBody());  
            } else {
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (Exception ex) {
            throw ex;
        }

        if (!employeesList.isEmpty()) {
            return employeesList;
        } else {
            return null;
        }
    }

    public class Employee {
        public Integer Id {get;set;}
        public String userName {get;set;}
        public String employee_id {get;set;}
        public String external_id {get;set;}
        public String first_name {get;set;}
        public String last_name {get;set;}
        public Integer primary_account_id {get;set;}
        public String ein_name {get;set;}
        public String status {get;set;}
        public Object _links{get; set;}

        public List<Employee> parseJSON(String json) {
            return (List<Employee>) System.JSON.deserialize(json, List<Employee>.class);
        }
    }

    public class TimeEntries {

        public Integer Id {get;set;}
        public String userName {get;set;}
        public String employee_id {get;set;}
        public String external_id {get;set;}
        public String first_name {get;set;}
        public String last_name {get;set;}
        public Integer primary_account_id {get;set;}
        public String ein_name {get;set;}
        public String status {get;set;}
        public Object _links{get; set;}
       
        public List<TimeEntries> parseJSON(String json) {
            return (List<TimeEntries>) System.JSON.deserialize(json, List<TimeEntries>.class);
        }
    }
}