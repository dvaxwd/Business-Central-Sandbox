// codeunit 50123 PurchaseCodeunit
// {
//     trigger OnRun()
//     var
//         myInt: Integer;
//         Purchase: Record "PurchaseTable";
//     begin
//         if Purchase.IsEmpty() then
//             Message('No purchase orders found.')
//     end;
    
//     //functions to insert default orders
//     procedure InsertDefaultOrder()
//         begin
//             InsertOrder('PO-001', 'Vendor A', 'Contact A', '1000', '2000', 'Open');
//             InsertOrder('PO-002', 'Vendor B', 'Contact B', '1500', '2500', 'Closed');
//             InsertOrder('PO-003', 'Vendor C', 'Contact C', '2000', '3000', 'Pending');
//         end;

//     //function to insert a new order
//     procedure InsertOrder(No: Code[12]; VendorName: Text[250]; Contact: Text[250]; VendorInvoiceNo: Code[20]; VendorShipmentNo: Code[20]; Status: Text[250])
//         var
//             Purchase: Record "PurchaseTable";
//         begin
//             Purchase.Init();
//             Purchase."NO." := 'PO-001';
//             Purchase."Vendor Name" := VendorName;
//             Purchase."Contact" := Contact;
//             Purchase."Vendor Invoice No." := VendorInvoiceNo;
//             Purchase."Vendor Shipment No." := VendorShipmentNo;
//             Purchase."Status" := Status;
//             Purchase.Insert();
//         end;
    
// }