public with sharing class CaseTriggerHandler {
    public static void handleAfterInsert(List<Case> newRecords) {
        for (Case c : newRecords) {
            Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper wrapper = new Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper();
            wrapper.description = c.Description;
            wrapper.subject = c.Subject;
            wrapper.email = 'vinaykumar@gmail.com';
            wrapper.priority = 1; // High
            wrapper.status = 2;   // Open

            // Converting the object into String
            makeCallout(JSON.serialize(wrapper));
        }
    }

    @future(callout=true)
    private static void makeCallout(String Params) {
        // Convert the String back into Object(Class)
        Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper wrapper = 
            (Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper) JSON.deserialize(Params, Ps_HelpDeskTicketUtils.FreshdeskTicketWrapper.class);

        Ps_HelpDeskTicketUtils.createTickets(wrapper);
    }
}
