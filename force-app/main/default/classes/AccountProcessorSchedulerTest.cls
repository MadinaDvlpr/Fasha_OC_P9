@isTest
public with sharing class AccountProcessorSchedulerTest {
    @isTest static void testAccountProcessorScheduler () {
        
        String cronExpr = '0 0 0 27 6 ? 2029';
        
        List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
        System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');
        
        System.Test.startTest();
      
        String jobId = 
            System.schedule('myUpdateAccountsBatch', cronExpr, new AccountProcessorScheduler());
        Test.stopTest();
        
        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
        System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
        System.assertEquals('AccountProcessorScheduler', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');
        
        List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
        System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
        System.assertEquals('AccountProcessorBatch', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');
    }
}