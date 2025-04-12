using {LogaliGroup as service} from '../service';

annotate service.Products with {
    product     @title        : 'Product';
    productName @title        : 'Product Name';
    category    @title        : 'Category';
    subCategory @title        : 'SubCategory';
    statu       @title        : 'Statu';
    rating      @title        : 'Rating';
    price       @title        : 'Price'  @Measures.ISOCurrency: currency;
    currency    @Common.IsCurrency: true;
};

annotate service.Products with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: product
        },
        {
            $Type: 'UI.DataField',
            Value: productName
        },
        {
            $Type: 'UI.DataField',
            Value: category_ID
        },
        {
            $Type: 'UI.DataField',
            Value: subCategory_ID
        },
        {
            $Type: 'UI.DataField',
            Value: statu_code
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#Variant1',
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: price
        }
    ],
    UI.DataPoint #Variant1: {
        $Type : 'UI.DataPointType',
        Visualization : #Rating,
        Value : rating
    }
);
