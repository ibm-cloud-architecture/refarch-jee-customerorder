---------------------------------------------------------------------
-- SQL file to insert a new residential customer into the ORDER DB --
---------------------------------------------------------------------

INSERT INTO CUSTOMER 
            (CUSTOMER_ID,
             NAME,
             USERNAME,
             TYPE,
             RESIDENTIAL_HOUSEHOLD_SIZE,
             RESIDENTIAL_FREQUENT_CUSTOMER,
             addressLine1,
             addressLine2,
             city,
             country,
             state,
             zip)
VALUES 
            ('An integer',
             'A name',
             'A unique username',
             'RESIDENTIAL',
             'An integer',
             'Y or N',
             'some street',
             'some street cont',
             'some city',
             'some country',
             'some state',
             'A zip code');