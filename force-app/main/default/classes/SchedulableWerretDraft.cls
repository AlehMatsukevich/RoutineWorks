public with sharing class SchedulableWerretDraft implements Schedualable {
    
    private static final String DEFAULT_SCHEDULE_NAME = 'Weekly Time Card Update';

    public static Id scheduleStatusChecker(String scheduleName) {
    return System.schedule(String.isNotBlank(scheduleName) ? scheduleName : DEFAULT_SCHEDULE_NAME, '0 0 10 ? * MON *', new SchedulableWerretDraft()); 
    }

    public void execute(SchedulableContext sc) {
        RestService.getTimeEntries();
        RestService.getEmployees();
        RestService.getProjects();
    }

}