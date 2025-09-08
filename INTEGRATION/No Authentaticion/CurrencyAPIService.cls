public with sharing class CurrencyAPIService {
    public static void getExchageRates(){
        /* Callouts only */
        /* Step 1 : Prepare the Request  */
        HttpRequest httpReq = new HttpRequest();
        /*Step 1.1: Send the Enpoint */
        httpReq.setEndPoint('https://open.er-api.com/v6/latest/USD');
        
        /*Step1.2: Set the Headers */
        httpReq.setHeader('Content-Type', 'application');
        httpReq.setHeader('Accept', 'application/json');  //JSON, XML, Text, HTML
        
        /*Step 1.3 : Set the Method */
        httpReq.setMethod('GET');  //GET, POST, PUT, PATCH, DELETE
        
        /*Step 2 : Send the Request  */
        Http htt = new Http();
        try{
            HttpResponse httpRes = htt.send(httpReq);
            /*
            getStatus()getStatusCode()
            getBody() getXMlStreamReader() --->Soap, getBodyAsBlob()
            */
            String responseBody = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            String status = httpRes.getStatus();
            
            System.System.debug('The Response from Currency API - '+ status);
            System.System.debug('The Response from Currency API - '+ statusCode);
            System.System.debug('The Response from Currency API - '+ responseBody);
        }catch(System.CalloutException calloutEx){
            if (calloutEx.getMessage().startsWith('System.CalloutException: unauthorized endpoint')) {
                //Remote Error--
                
            }
            
        }catch(System.Exception ex){
            if(ex.getMessage().startsWith('System.CalloutException: unauthorized endpoint')){
                
            }

        }
        
    }
}