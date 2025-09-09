public with sharing class Ps_HelpDeskTicketUtils {
    /*
    Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper wrapper = new Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper();
    wrapper.description = 'This is a test ticket';
    wrapper.subject = 'Test Ticket';
    wrapper.email ='vinaykumar@gmail.com';
    wrapper.priority = 1;
    wrapper.status = 2;
    
    Ps_HelpDeskTicketUtils.createTickets(wrapper);
     */
    
    public class FreshdeskTicketWrapper {
        public String description ;
        public String subject;
        public String email;
        public Integer priority;
        public Integer status;
    }
    
    public static void createTickets(FreshdeskTicketWrapper wrapper) {
        
        // Replace X with your API key or put it in a Custom Label
        String header = System.Label.Helpdesk_Username + ':' + 'X';
        Blob headerValue = Blob.valueOf(header);
        
        String requestBody = '{' +
            ' "description": "'+ wrapper.description +'",' +   // fixed: wrapper.body → wrapper.description
            ' "subject": "'+ wrapper.subject +'",' +
            ' "email": "'+ wrapper.email +'",' +
            ' "priority": '+ wrapper.priority +',' +
            ' "status": '+ wrapper.status +
            '}';
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndPoint('https://vinaykumargothala23-help.freshdesk.com/api/v2/tickets');
        httpReq.setMethod('POST');
        httpReq.setBody(requestBody);
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Accept','application/json');
        httpReq.setHeader('Authorization','Basic ' + EncodingUtil.base64Encode(headerValue)); // fixed spacing + variable case
        
        Http http = new Http();
        
        try {
            HttpResponse httpRes = http.send(httpReq);
            
            if (httpRes.getStatusCode() == 201) {
                System.debug('SUCCESS \n ' + httpRes.getBody());
            } else {
                System.debug('ERROR ' + httpRes.getStatusCode() + ' \n ' + httpRes.getBody());
            }
        } catch (System.CalloutException ex) {
            System.debug('Callout exception: ' + ex.getMessage());
        } catch (System.Exception ex) {
            System.debug('General exception: ' + ex.getMessage());
        }
    }
}