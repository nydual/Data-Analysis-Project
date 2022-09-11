-- Cleaning `nashville housing data` using SQL queries

SELECT *
FROM DataCleaning `nashville housing data`;

-- Standardize Date Format

SELECT saleDate, CONVERT(Date,SaleDate)
FROM DataCleaning `nashville housing data`

UPDATE `nashville housing data`
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE `nashville housing data`
ADD SaleDateConverted Date

UPDATE `nashville housing data`
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM DataCleaning `nashville housing data`
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataCleaning `nashville housing data`a
JOIN DataCleaning `nashville housing data` b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataCleaning `nashville housing data`a
JOIN DataCleaning `nashville housing data` b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM DataCleaning `nashville housing data`;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM DataCleaning `nashville housing data`;


ALTER TABLE `nashville housing data`
ADD PropertySplitAddress Nvarchar(255);

UPDATE `nashville housing data`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );


ALTER TABLE `nashville housing data`
ADD PropertySplitCity Nvarchar(255);

UPDATE `nashville housing data`
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));




SELECT *
FROM DataCleaning `nashville housing data`;





SELECT OwnerAddress
FROM DataCleaning `nashville housing data`

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM DataCleaning `nashville housing data`

ALTER TABLE `nashville housing data`
ADD OwnerSplitAddress Nvarchar(255);


UPDATE `nashville housing data`
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE `nashville housing data`
ADD OwnerSplitCity Nvarchar(255);

UPDATE `nashville housing data`
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);



ALTER TABLE `nashville housing data`
ADD OwnerSplitState Nvarchar(255);

UPDATE `nashville housing data`
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);



SELECT *
FROM DataCleaning `nashville housing data`;




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM DataCleaning `nashville housing data`
GROUP BY SoldAsVacant
ORDER BY 2;




SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM DataCleaning `nashville housing data`;















