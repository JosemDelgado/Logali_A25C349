using {LogaliGroup as service} from '../service';
using from './annotations-suppliers';
using from './annotations-productdetails.cds';
using from './annotations-reviews';

annotate service.Products with {
    product     @title            : 'Product';
    productName @title            : 'Product Name';
    category    @title            : 'Category';
    subCategory @title            : 'Sub Category';
    supplier    @title            : 'Supplier';
    statu       @title            : 'Statu';
    rating      @title            : 'Rating';
    price       @title            : 'Price'  @Measures.ISOCurrency: currency;
    currency    @Common.IsCurrency: true;
};

annotate service.Products with {
    statu       @Common: {
        Text           : statu.name,
        TextArrangement: #TextOnly
    };
    category    @Common: {
        Text           : category.category,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID'
                }
            ]
        },
    };
    subCategory @Common: {
        Text           : subCategory.subCategory,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_SubCategories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'category_ID',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : subCategory_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    supplier @Common: {
        Text : supplier.supplierName,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : supplier_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    }
};


annotate service.Products with @(
    Capabilities.FilterRestrictions: {
        $Type : 'Capabilities.FilterRestrictionsType',
        FilterExpressionRestrictions : [
            {
                $Type : 'Capabilities.FilterExpressionRestrictionType',
                Property : product,
                AllowedExpressions : 'SearchExpression'
            }
        ]
    },
    UI.HeaderInfo         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : productName
        },
        Description: {
            $Type : 'UI.DataField',
            Value : product
        }
    },
    UI.SelectionFields    : [
        product,
        supplier_ID,
        category_ID,
        subCategory_ID,
        statu_code
    ],
    UI.LineItem           : [
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
            $Type                : 'UI.DataField',
            Value                : statu_code,
            Criticality          : statu.criticality,
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type                : 'UI.DataFieldForAnnotation',
            Target               : '@UI.DataPoint#Variant1',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: price
        }
    ],
    UI.DataPoint #Variant1: {
        $Type        : 'UI.DataPointType',
        Visualization: #Rating,
        Value        : rating
    },
    UI.FieldGroup #SupplierAndCategory : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : supplier_ID
            },
            {
                $Type : 'UI.DataField',
                Value : category_ID
            },
            {
                $Type : 'UI.DataField',
                Value : subCategory_ID
            }
        ]
    },
    UI.FieldGroup #ProductDescription: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : description
            }
        ]
    },
    UI.FieldGroup #Statu : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : statu_code,
                Criticality : statu.criticality,
                Label : ''
            }
        ]
    },
    UI.FieldGroup #Price : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : price,
                Label :''
            }
        ]
    },
    UI.HeaderFacets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#SupplierAndCategory',
            ID : 'SupplierAndCategory'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#ProductDescription',
            ID : 'ProductDescription',
            Label : 'Product Description'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Statu',
            ID : 'ProductStatu',
            Label : 'Availability'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Price',
            ID : 'Price',
            Label : 'Price'
        }
    ],
    UI.Facets  : [
        {
            $Type : 'UI.CollectionFacet',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/@UI.FieldGroup#Supplier',
                    Label : 'Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/contact/@UI.FieldGroup#Contact',
                    Label: 'Contact Person'
                }
            ],
            Label : 'Supplier Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'detail/@UI.FieldGroup',
            Label : 'Product Information',
            ID : 'ProductInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID : 'Reviews'
        }
    ]
);
