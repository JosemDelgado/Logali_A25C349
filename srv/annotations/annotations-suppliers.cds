using {LogaliGroup as service} from '../service';
using from './annotations-contacts';

annotate service.Suppliers with {
    @title: 'Suppliers'
    ID            @Common: {
        Text           : supplierName,
        TextArrangement: #TextOnly
    };
    supplier      @title : 'Supplier'       @Common.FieldControl: #ReadOnly;
    supplierName  @title : 'Supplier Name'  @Common.FieldControl: #ReadOnly;
    webAddress    @title : 'Web Address'    @Common.FieldControl: #ReadOnly;
};

annotate service.Suppliers with @(UI.FieldGroup #Supplier: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Value: supplier
        },
        {
            $Type: 'UI.DataField',
            Value: supplierName
        },
        {
            $Type: 'UI.DataField',
            Value: webAddress
        }
    ]
}, );
