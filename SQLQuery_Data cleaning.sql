

select * from dbo.Sheet1$

--------------------------------------------------------------------------------------------------------------------------

select SaleDate from dbo.Sheet1$

--removal of time part from saledate column 

ALTER TABLE Sheet1$
Add SaleDateConverted Date;

Update Sheet1$
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------


--populate property address data where entries were null

select *   from dbo.Sheet1$
where PropertyAddress is Null
oRder by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from dbo.Sheet1$ as a
join dbo.Sheet1$ as b

	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null
	

update a 
set propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from dbo.Sheet1$ as a
join dbo.Sheet1$ as b

	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	--------------------------------------------------------------------------------------------------------------------------

--breaking out property address into individual columns (address, city, state)


select PropertyAddress from dbo.Sheet1$
--where PropertyAddress is Null
--oRder by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From dbo.Sheet1$


ALTER TABLE Sheet1$
Add PropertySplitAddress Nvarchar(255);

Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Sheet1$
Add PropertySplitCity Nvarchar(255);

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From dbo.Sheet1$


--------------------------------------------------------------------------------------------------------------------------
--breaking out ownership address into individual columns (address, city, state)

Select OwnerAddress
From dbo.Sheet1$


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.Sheet1$


ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dbo.Sheet1$



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.Sheet1$
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.Sheet1$


Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.Sheet1$


Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


----------------------------------------------------------------------------------------------------------------------------------------------------------




-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.Sheet1$
--order by ParcelID
)
select *
From RowNumCTE

Where row_num > 1
Order by PropertyAddress



Select *
From dbo.Sheet1$



----------------------------------------------------------------------------------------------------------------------------------------------------------




-- Delete Unused Columns



Select *
From dbo.Sheet1$


ALTER TABLE dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------






