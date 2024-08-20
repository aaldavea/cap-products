namespace com.logali;

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

/* Definir tipo matriz en CAP una entidad con un array
type EmailAddresses_01 : array of {
    kind  : String;
    email : String;
};

type EmailAddresses_02 {
    kind  : String;
    email : String;
};

entity Emails {
    email_01 :      EmailAddresses_01; // es un array dentro de una entidad
    email_02 : many EmailAddresses_02; // es un array dentro de una entidad
    email_03 : many { // es un array dentro de una entidad
        kind  : String;
        email : String;
    }
};*/

/* Enumeraciones en lenguaje CAP, para definir un rango de posibles valores
type Gender : String enum {
    male;
    female;
};

entity Order {
    clientgender : Gender;
    status       : Integer enum {
        submitted = 1;
        fulfiller = 2;
        shipped   = 3;
        cancel    = -1;
    };
    priority: String @assert.range enum {
        high;
        medium;
        low;
    };
};*/

/* Elementos virtuales
entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal; //Sirve para devolver datos pero no permite crear
        virtual discount_2 : Decimal; //Sirve para devolver datos pero no permite crear
};*/

type Dec : Decimal(16, 2);

entity Products {
    key ID               : UUID;
        Name             : String not null; //Restricciones que no debe ser nulo
        //Name             : String default 'NoName'; //Valores por defecto
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now; //Valores por defecto
        DiscontinuedDate : DateTime;
        Price            : Dec;
        Height           : type of Price; //Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        //***** ASOCIACIONES ADMINISTRADAS ******/
        Supplier         : Association to Suppliers;
        UnitOfMeasure    : Association to one UnitOfMeasures;
        Category         : Association to Categories;

        //***** ASOCIACIONES CON MANY ******/
        ToSalesData      : Association to many SalesData
                               on ToSalesData.Product = $self;
        Reviews          : Association to many ProductReviews
                               on Reviews.Product = $self;

//***** ASOCIACIONES NO ADMINISTRADAS ******/
/*Supplier_Id       : UUID;
ToSupplier        : Association to one Suppliers
                        on ToSupplier.ID = Supplier_Id;
UnitOfMeasures_Id : String(2);
toUnitOfMeasure   : Association to UnitOfMeasures
                        on toUnitOfMeasure.ID = UnitOfMeasures_Id;*/
};

entity Suppliers {
    key ID      : UUID;
        Name    : type of Products : Name; //String
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many Products
                      on Product.Supplier = $self;
};

entity Categories {
    key ID   : String(1);
        Name : String;
};

entity StockAvailability {
    key ID          : Integer;
        Description : String;
};

entity Currencies {
    key ID          : String(3);
        Description : String;
};

entity UnitOfMeasures {
    key ID          : String(2);
        Description : String;
};

entity DimensionUnits {
    key ID          : String(2);
        Description : String;
};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
};

entity ProductReviews {
    key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to Products;
};

entity SalesData {
    key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        //****** ASOCIACIONES ADMINISTRADAS******/
        Product       : Association to Products;
        Currency      : Association to Currencies;
        DeliveryMonth : Association to Months;
};

//*********** Entidad con Selects ***********//

entity SelProducts   as select from Products;

entity SelProducts1  as
    select from Products {
        *
    };

entity SelProducts2  as
    select from Products {
        Name,
        Price,
        Quantity
    };

// Entidad con Select
entity SelProducts3  as
    select from Products
    left join ProductReviews
        on Products.Name = ProductReviews.Name
    {
        Rating,
        Products.Name,
        sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.Name
    order by
        Rating;
//*********** End Entidad con Selects ***********//


//*********** Entidad con Projection ***********//
entity ProjProducts  as projection on Products;

entity ProjProducts2 as
    projection on Products {
        *
    };

entity ProjProducts3 as
    projection on Products {
        ReleaseDate,
        Name
    };
//*********** End Entidad con Projection ***********//

//*********** Entidad con Parametros ***********//
/*entity ParamProducts(pName : String)     as
    select from Products {
        Name,
        Price,
        Quantity
    }
    where
        Name = :pName;

entity ProjParamProducts(pName : String) as projection on Products
                                            where
                                                Name = :pName;*/
//*********** End Entidad con Parametros ***********//

//*********** Entidad existente se hace extensión ***********//
extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
};
//*********** End Entidad existente se hace extensión ***********//
