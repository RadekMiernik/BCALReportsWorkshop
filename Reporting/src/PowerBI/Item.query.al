query 50100 "MNB Item"
{
    APIGroup = 'rmiAnalytics';
    APIPublisher = 'rmi';
    APIVersion = 'v1.0';
    DataAccessIntent = ReadOnly; //Note: IMPORTANT
    EntityName = 'rmiItemQuery';
    EntitySetName = 'item';
    QueryType = API;

    elements
    {
        dataitem(item; Item)
        {
            column(no; "No.") { }
            column(descritpion; Description) { }
        }
    }
}