# BC20_0_CA_BOC-Currency-Service-Patch

# Temporary Patch Fix for Bank of Canada Currency Exchange Rates Not Being Imported in Business Central 20.0.37253.40150 CA
For a number of Business Central customers I work with, the default ‘BOC’ Bank of Canada “Currency Exch. Rate Service” stopped working in the BC 2022 Wave 1 (20.0) update.
 
## The Issue
The BOC service requires that a “Transformation Rule” be applied to the Bank of Canada’s Currency Codes. Before they will come in, the BOC codes need to be converted to BC’s default codes. (I.e., ‘FXUSDCAD’ must be imported as ‘USD’.)  [Tara Spence](https://www.linkedin.com/in/tara-spence-0318b3134/) discovered that this Transformation Rule is not being applied in BC 20.0.

In BC 20.0.37253.40150 CA, a new function was introduced in the "Map Currency Exchange Rate" codeunit 1280: “GetAndAssignCurrencyCode”. Unfortunately, this function currently applies the Transformation Rule after it attempts to resolve BC Currency Code. The BOC’s codes don’t match BC’s default codes in this case, so the process exits without importing any data.
 
## Resolution
A temporary patch fix for this is to “roll back” to the 19.5 version of the “Map Currency Exchange Rate” codeunit using a per-tenant extension. BC20_0_CA_BOC-Currency-Service-Patch is an example of how to do this.

**This type of patch should only be used temporarily, because it takes the codeunit out of Microsoft’s maintenance/upgrade path and bypasses any 3rd party extensions.**

### Part I:
#### Code
A “new” codeunit 80989 "PTE-ATCTMP Map FCY Rate" is created by copying BC 19.5.36567.37779’s working "Map Currency Exchange Rate" codeunit 1280.
#### Configuration
1. On the BOC “Currency Exch. Rate Service” card, in the “Field Mappin” part, click the “Data Exchange Definition” action in the “Manage” group.
 
2. On the “Data Exchange Definition” page, in the “Line Definitions” part, click the “Field Mapping” action in the “Manage” group.
 
3. On the “Field Mapping” page, change the “Mapping Codeunit” to the id of your “rolled-back” custom codeunit. (This is 80989 in my sample app.) 

If you have the BOC “Currency Exch. Rate Service” enabled, your exchange rates should start coming in again.

### Part II:
Part II is somewhat optional. Even though the service is “fixed”, the “Preview” button on the BOC “Currency Exch. Rate Service” card will still not work. It uses a function to populate the temporary dataset that invokes a hard-coded call to the 20.0 version of the "Map Currency Exchange Rate" codeunit 1280.

My quick and dirty patch for this involves another “save-as”.

I made a copy of codeunit 1281 "Update Currency Exchange Rates", which contains the GenerateTempDataFromService procedure that is invoked by the Preview action. I then changed the code to call our new custom extension codeunit 80989.

(I commented out everything that I don’t need for this process, and had to switch the ExecuteWebServiceRequest process from dot-net based http calls to AL-based http objects.)

Using a PageExtension, I replaced the Preview action on the “Currency Exch. Rate Service” card with a Patched Preview action (copied from ‘Preview’) that calls this codeunit.
