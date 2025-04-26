using {LogaliGroup as service} from '../service';

annotate service.Reviews with {
    rating   @title: 'Rating';
    date @title: 'Date';
    reviewText @title: 'Review Text';
};


annotate service.Reviews with @(
    UI.LineItem: [
        
    ]
);