public with sharing class OpencageGeoCoderService {
    public static void reverseGeoCoding(String accountId){ //arguments
        /*Step0: get the Lattitude and longitude for given account */
        Account accRecord = [SELECT Id, Location__Latitude__s, Location__Longitude__s 
                               FROM Account 
                               WHERE Id =: accountId 
                                 AND Location__Latitude__s != null 
                                 AND Location__Longitude__s != null
                               LIMIT 1
                            ];
        /*Step 0.1 : Prepare the Query Params */
        String queryParams = accRecord.Location__Latitude__s + ',' + accRecord.Location__Longitude__s;
        
        /* Callouts only */
        /* Step 1 : Prepare the Request  */
        HttpRequest httpReq = new HttpRequest();
        /*Step 1.1: Send the Enpoint */
        httpReq.setEndPoint(System.Label.OPENCAGE_API_URL+'?key='
            +System.Label.OPENCAGE_API_KEY+'&q='+queryParams+'&pretty=1');
        
        /*Step1.2: Set the Headers */
        httpReq.setHeader('Content-Type', 'application');
        httpReq.setHeader('Accept', 'application/json');  //JSON, XML, Text, HTML
        
        /*Step 1.3 : Set the Method */
        httpReq.setMethod('GET');  //GET, POST, PUT, PATCH, DELETE
        
        /*Step 2 : Send the Request  */
        Http htt = new Http();
        try {
            HttpResponse httpRes = htt.send(httpReq);
            String responseBody = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            
            //Get , 200
            if(statusCode == 200){
                //deserialize, deserializeUnTyped, deserializeStrict
                OpenCageReverseResponse wrapper = (OpenCageReverseResponse)System.JSON.deserialize(responseBody, OpenCageReverseResponse.class);
                if(wrapper?.results?.size() > 0 ){
                    OpenCageReverseResponse.results rslt = wrapper.results.get(0);
                    
                    // Update Account Record
                    accRecord.BillingStreet      = rslt?.components?.road;
                    accRecord.BillingCity        = rslt?.components?.city;
                    accRecord.BillingState       = rslt?.components?.state;
                    accRecord.BillingPostalCode  = rslt?.components?.postcode;
                    accRecord.BillingCountry     = rslt?.components?.country;
                    
                    accRecord.ShippingStreet     = rslt?.components?.road;
                    accRecord.ShippingCity       = rslt?.components?.city;
                    accRecord.ShippingState      = rslt?.components?.state;
                    accRecord.ShippingPostalCode = rslt?.components?.postcode;
                    accRecord.ShippingCountry    = rslt?.components?.country;
                    
                    update accRecord;
                } else {
                    //error handling code .....
                }
            }
        } catch(System.CalloutException calloutEx){
            System.debug('System.CalloutException .... ' + calloutEx.getStackTraceString());
            if(String.valueOf(calloutEx).startsWith('System.CalloutException: Unauthorised endpoint')){
                // Remote Site missing Error -
                System.debug(' CalloutException ');
            }
        } catch(System.Exception ex){
            System.debug('Exception Executed ... '+ ex.getStackTraceString());
            if(String.valueOf(ex).startsWith('System.CalloutException: Unauthorised endpoint')){
                // Remote Site missing Error -
                System.debug(' Executed ');
            }
        }
    }
}
