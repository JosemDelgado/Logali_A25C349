using {LogaliGroup as service} from '../service';

annotate service.ProductDetails with {
    baseUnit   @title: 'Base Unit';
    width      @title: 'Width'   @Measures.Unit: unitVolume;
    height     @title: 'Height'  @Measures.Unit: unitVolume;
    depth      @title: 'Depth'   @Measures.Unit: unitVolume;
    weight     @title: 'Weight'  @Measures.Unit: unitWeight;
    unitVolume @Common.IsUnit;
    unitWeight @Common.IsUnit;
};

annotate service.ProductDetails with @(UI.FieldGroup: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Value: baseUnit,
        },
        {
            $Type: 'UI.DataField',
            Value: width,
        },
        {
            $Type: 'UI.DataField',
            Value: height,
        },
        {
            $Type: 'UI.DataField',
            Value: depth,
        },
        {
            $Type: 'UI.DataField',
            Value: weight
        }
    ],
    Label: 'Technical Data'
});
