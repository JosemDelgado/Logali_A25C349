using {com.logaligroup as entities} from '../db/schema';
using {API_BUSINESS_PARTNER as cloud} from './external/API_BUSINESS_PARTNER';
using {API_BUSINESS_PARTNER_CLUD as onpremise} from './external/API_BUSINESS_PARTNER_CLUD';

service LogaliGroup {
    type dialog {
        option: String(10); //Add or Discount
        amount: Integer;
    }

    entity Products         as projection on entities.Products;
    entity ProductDetails   as projection on entities.ProductDetails;
    entity Suppliers        as projection on entities.Suppliers;
    entity Contacts         as projection on entities.Contacts;
    entity Reviews          as projection on entities.Reviews;
    entity Inventories      as projection on entities.Inventories actions {
        @Core.OperationAvailable: {
            $edmJson: {
                $If:[
                    {
                        $Eq:[
                            {
                                $Path: 'in/product/IsActiveEntity'
                            },
                            false
                        ]
                    },
                    false,
                    true
                ]
            }
        }
        @Common : { 
            SideEffects : {
                $Type : 'Common.SideEffectsType',
                TargetProperties : [
                    'in/quantity'
                ],
                TargetEntities : [
                    in.product
                ],
            },
         }
        action setStock (
            in : $self,
            option: dialog:option,
            amount: dialog:amount
        )
    };
    entity Sales            as projection on entities.Sales;
    
    /**Code List */
    entity Status           as projection on entities.Status;
    entity Options          as projection on entities.Options;

    /** Value Helps */
    entity VH_Categories    as projection on entities.Categories;
    entity VH_SubCategories as projection on entities.SubCategories;
    entity VH_Departments   as projection on entities.Departments;

    /** Entidades externas */
    entity CBusinessPartner as projection on cloud.A_BusinessPartner {
        key BusinessPartner as ID,
            FirstName as FirstName,
            LastName as LastName
    };

    entity CSuppliers as projection on cloud.A_Supplier {
        Supplier as ID,
        SupplierName as SupplierName,
        SupplierFullName as FullName
    };

    entity CCustomer as projection on onpremise.A_Customer {
        Customer as ID,
        CustomerName,
        CustomerFullName
    };
};
