---------------------------------------------------------------------
-- SQL file to insert a new business customer into the ORDER DB --
---------------------------------------------------------------------

INSERT INTO CUSTOMER 
            (CUSTOMER_ID,
             NAME,
             USERNAME,
             TYPE,
             BUSINESS_VOLUME_DISCOUNT,
             BUSINESS_PARTNER,
             BUSINESS_DESCRIPTION, 
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
             'BUSINESS',
             'Y or N',
             'Y or N',
             'some description'
             'some street',
             'some street cont',
             'some city',
             'some country',
             'some state',
             'A zip code');