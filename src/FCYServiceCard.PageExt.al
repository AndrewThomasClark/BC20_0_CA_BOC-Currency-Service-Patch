pageextension 80989 "PTE-ATCTMP FCY Service Card" extends "Curr. Exch. Rate Service Card"
{
    actions
    {
        modify(Preview)
        {
            Visible = false;
        }

        addafter(Preview)
        {
            action(PTEATCTMPPreview)
            {
                ApplicationArea = Suite;
                Caption = 'Patched Preview';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'PTE-BC20_0_CA_BOC temporary patch fix for the Preview action in BC20.0.';

                trigger OnAction()
                var
                    TempCurrencyExchangeRate: Record "Currency Exchange Rate" temporary;
                    // UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
                    UpdateCurrencyExchangeRates: Codeunit "PTE-ATCTMP Update FCY";
                begin
                    Rec.TestField(Code);
                    // VerifyServiceURL;
                    // VerifyDataExchangeLineDefinition;
                    UpdateCurrencyExchangeRates.GenerateTempDataFromService(TempCurrencyExchangeRate, Rec);
                    PAGE.Run(PAGE::"Currency Exchange Rates", TempCurrencyExchangeRate);
                end;
            }
        }
    }
}
