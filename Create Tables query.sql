-- Create the 'store_milano_cleaned' table for the original CSV import
CREATE TABLE store_milano_cleaned (
    "Customer Account ID" BIGINT,        -- Unique Customer Identifier
    "Actual Tier ID" TEXT,               -- Loyalty Program Level (Case-sensitive)
    "Customer Creation Date DESC" DATE,  -- Date of Loyalty Program Registration
    "GENERATIONS" TEXT,                  -- Customer's Generation (Gen Z, Gen X, etc.)
    "Age ID" INT,                        -- Age of the customer
    "Gender DESC" TEXT,                  -- Gender (MALE, FEMALE or NOT SPECIFIED)
    "Region ID" TEXT,                    -- Region of Residence
    "District ID" TEXT,                  -- Province of Residence
    "Town ID" TEXT,                      -- City of Residence

    -- Consent Flags (Boolean)
    "Marketing Consent Flag ID" BOOLEAN,  -- Marketing Consent (TRUE/FALSE)
    "Primary eMail Present ID" BOOLEAN,   -- Email Presence (TRUE/FALSE)
    "Email Consent ID" BOOLEAN,           -- Email Consent (TRUE/FALSE)
    "Mobile Phone Present ID" BOOLEAN,    -- Phone Presence (TRUE/FALSE)
    "SMS Consent ID" BOOLEAN,             -- SMS Consent (TRUE/FALSE)
    "Call Consent ID" BOOLEAN,            -- Call Consent (TRUE/FALSE)
    "Is Ecommerce" BOOLEAN,               -- E-commerce Registration (TRUE/FALSE)

    -- Sales Data
    "Sales Date DESC" DATE,                     -- Date of Purchase
    "Alternative Division DESC_COMPLETE" TEXT,  -- Product Division (Category)
    "Actual Ownership Type DESC" TEXT,          -- Ownership Type (Direct Sale or Concession)
    "Brand DESC_COMPLETE" TEXT,                 -- Brand Name

    -- Transaction Details
    "Customer Sales (qty)" INT,               -- Number of Products Purchased
    "Customer Sales (val)" NUMERIC(10,2),     -- Amount Spent (€)
    "Customer Discount (val)" NUMERIC(10,2),  -- Discount Amount (€)
    "Customer Discount (%)" NUMERIC(5,2)      -- Discount Percentage (%)
);


--------------------------------------------------------------------------------------------------------
-- Create dimension tables

-- create the dimLocation table - Location information to avoid transitive redundancies with Region, District, City
CREATE TABLE dimLocation (
    LocationID SERIAL PRIMARY KEY,        -- Unique identifier for location
    Region TEXT,                          -- Region of residence
    District TEXT,                        -- Province of residence
    City TEXT,                            -- City of residence
    CONSTRAINT uq_location UNIQUE (Region, District, City)  -- Ensure one row per unique combination
);

-- create the dimCustomer table - Customer information
CREATE TABLE dimCustomer (
    CustomerAccountID BIGINT PRIMARY KEY, -- Use CustomerAccountID as the primary key directly
    LocationID INT REFERENCES dimLocation(LocationID),  -- Foreign Key to dimLocation
    Gender TEXT,                          -- Customer's gender
    LoyaltyTier TEXT,                     -- Loyalty program level (staRter, Runner, loveR, heRo)
    CustomerJoinDate DATE,                -- Date of registration in loyalty program
    Generation TEXT,                      -- Customer's generational group (e.g., Gen Z)
    Age INT,                              -- Customer's age
    ConsentMarketing BOOLEAN,             -- 1 = Yes, 0 = No (Marketing communication consent)
    PresentEmail BOOLEAN,                 -- 1 = Yes, 0 = No (Indicates if email is provided)
    ConsentEmail BOOLEAN,                 -- 1 = Yes, 0 = No (Consent for email communication)
    PresentPhone BOOLEAN,                 -- 1 = Yes, 0 = No (Indicates if phone number is provided)
    ConsentSMS BOOLEAN,                   -- 1 = Yes, 0 = No (Consent for SMS communication)
    ConsentCall BOOLEAN,                  -- 1 = Yes, 0 = No (Consent for call communication)
    IsEcommerceUser BOOLEAN               -- 1 = Yes, 0 = No (Indicates if registered for eCommerce)
);

-- create the dimBrand table - Brand information
CREATE TABLE dimBrand (
    BrandID SERIAL PRIMARY KEY,  -- Unique identifier for the brand
    BrandName TEXT UNIQUE        -- Name of the brand
);

-- create the dimDivision - Product divisions
CREATE TABLE dimDivision (
    DivisionID SERIAL PRIMARY KEY,  -- Unique identifier for product division
    DivisionName TEXT UNIQUE        -- Name of the division (e.g., MEN, WOMEN, CHILDREN)
);

-- create dimLoyalty - Loyalty tiers
CREATE TABLE dimLoyalty (
    LoyaltyTierID SERIAL PRIMARY KEY,  -- Unique identifier for loyalty tier
    LoyaltyTier TEXT UNIQUE            -- Tier name (staRter, Runner, loveR, heRo)
);

-- Create the dimOwnershipType table - Ownership types (NEW)
CREATE TABLE dimOwnershipType (
    OwnershipTypeID SERIAL PRIMARY KEY,  -- Unique identifier for ownership type
    OwnershipType TEXT UNIQUE            -- Ownership type (Direct Sale or Concession)
);

--------------------------------------------------------------------------------------------------------
-- Populate dimension tables

-- Populate dimLocation
INSERT INTO dimLocation (Region, District, City)
SELECT DISTINCT
    "Region ID",
    "District ID",
    "Town ID"
FROM store_milano_cleaned;

-- Populate dimCustomer
INSERT INTO dimCustomer (
    CustomerAccountID, LocationID, Gender, LoyaltyTier, CustomerJoinDate, Generation, Age,
    ConsentMarketing, PresentEmail, ConsentEmail,
    PresentPhone, ConsentSMS, ConsentCall, IsEcommerceUser
)
SELECT DISTINCT 
    s."Customer Account ID",
    l.LocationID,
    s."Gender DESC",
    s."Actual Tier ID",
    s."Customer Creation Date DESC",
    s."GENERATIONS",
    s."Age ID",
    s."Marketing Consent Flag ID",
    s."Primary eMail Present ID",
    s."Email Consent ID",
    s."Mobile Phone Present ID",
    s."SMS Consent ID",
    s."Call Consent ID",
    s."Is Ecommerce"
FROM store_milano_cleaned s
JOIN dimLocation l
  ON s."Region ID"   = l.Region
 AND s."District ID" = l.District
 AND s."Town ID"     = l.City;

-- Populate dimBrand
INSERT INTO dimBrand (BrandName)
SELECT DISTINCT "Brand DESC_COMPLETE" FROM store_milano_cleaned;

-- Populate dimDivision
INSERT INTO dimDivision (DivisionName)
SELECT DISTINCT "Alternative Division DESC_COMPLETE" FROM store_milano_cleaned;

-- Populate dimLoyalty
INSERT INTO dimLoyalty (LoyaltyTier)
SELECT DISTINCT "Actual Tier ID" FROM store_milano_cleaned;

-- Populate dimOwnershipType (NEW)
INSERT INTO dimOwnershipType (OwnershipType)
SELECT DISTINCT "Actual Ownership Type DESC" FROM store_milano_cleaned;

--------------------------------------------------------------------------------------------------------
-- Create fact table

-- Create the FactSales table
CREATE TABLE factSales (
    SaleID SERIAL PRIMARY KEY,        -- Unique identifier for each transaction
    CustomerAccountID BIGINT,         -- Foreign Key to dimCustomer (who made the purchase)
    BrandID INT,                      -- Foreign Key to dimBrand (which brand was purchased)
    DivisionID INT,                   -- Foreign Key to dimDivision (product category/division)
    OwnershipTypeID INT,              -- Foreign Key to dimOwnershipType (NEW)
    SaleDate DATE,                    -- Date of the transaction
    QuantityPurchased INT,            -- Number of products purchased
    SalesAmount NUMERIC(10,2),        -- Total amount spent (€)
    DiscountValue NUMERIC(10,2),      -- Absolute discount amount (€)
    DiscountPercentage NUMERIC(5,2),  -- Percentage discount applied

    -- Foreign Key Constraints
    CONSTRAINT fk_customer  FOREIGN KEY (CustomerAccountID) REFERENCES dimCustomer(CustomerAccountID),
    CONSTRAINT fk_brand     FOREIGN KEY (BrandID)           REFERENCES dimBrand(BrandID),
    CONSTRAINT fk_division  FOREIGN KEY (DivisionID)        REFERENCES dimDivision(DivisionID),
    CONSTRAINT fk_ownership FOREIGN KEY (OwnershipTypeID)   REFERENCES dimOwnershipType(OwnershipTypeID)
);

--------------------------------------------------------------------------------------------------------
-- Populate factSales

INSERT INTO factSales (
    CustomerAccountID, BrandID, DivisionID, OwnershipTypeID, SaleDate, 
    QuantityPurchased, SalesAmount, DiscountValue, DiscountPercentage
)
SELECT 
    c.CustomerAccountID, 
    b.BrandID, 
    d.DivisionID, 
    o.OwnershipTypeID,
    s."Sales Date DESC", 
    s."Customer Sales (qty)", 
    s."Customer Sales (val)", 
    s."Customer Discount (val)", 
    s."Customer Discount (%)"
FROM store_milano_cleaned s
JOIN dimCustomer     c ON s."Customer Account ID"                  = c.CustomerAccountID
JOIN dimBrand        b ON s."Brand DESC_COMPLETE"                  = b.BrandName
JOIN dimDivision     d ON s."Alternative Division DESC_COMPLETE"   = d.DivisionName
JOIN dimOwnershipType o ON s."Actual Ownership Type DESC"          = o.OwnershipType;

--------------------------------------------------------------------------------------------------------
-- delete the table used to import data
DROP TABLE store_milano_cleaned;
