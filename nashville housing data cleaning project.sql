
select * 
from [portfolioproject&]..nashvillehousing


select saledateconverted, CONVERT(DATE, saledate)
from [portfolioproject&]..nashvillehousing

update nashvillehousing
SET saledate = CONVERT(DATE, saledate)

ALTER TABLE nashvillehousing
add saledateconverted date;

update nashvillehousing
SET saledateconverted = CONVERT(DATE, saledate)



select propertyaddress
from [portfolioproject&]..nashvillehousing
where propertyaddress is null

select *
from [portfolioproject&]..nashvillehousing
where propertyaddress is null

select *
from [portfolioproject&]..nashvillehousing
--where propertyaddress is null
order by parcelID

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
from [portfolioproject&]..nashvillehousing a
JOIN [portfolioproject&]..nashvillehousing b
 on a.parcelid = b.parcelid
 and a.uniqueid <> b.uniqueid
 where a.propertyaddress is null

 update a
 SET propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
 from [portfolioproject&]..nashvillehousing a
JOIN [portfolioproject&]..nashvillehousing b
 on a.parcelid = b.parcelid
 and a.uniqueid <> b.uniqueid
 where a.propertyaddress is null

 select propertyaddress
 from [portfolioproject&]..nashvillehousing

 SELECT
 SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as address
 , SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, LEN(propertyaddress)) as address
 from [portfolioproject&]..nashvillehousing


 ALTER TABLE nashvillehousing
 add propertysplitaddress varchar(255);

 update nashvillehousing
 SET propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

 ALTER TABLE nashvillehousing
 add propertysplitcity varchar(255);

 update nashvillehousing
 SET propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1 , LEN(propertyaddress))

 select * 
 from [portfolioproject&]..nashvillehousing


 select owneraddress
 from [portfolioproject&]..nashvillehousing

 select
 PARSENAME(REPLACE(owneraddress, ',', '.'), 3)
  ,PARSENAME(REPLACE(owneraddress, ',', '.'), 2)
  ,PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
 from [portfolioproject&]..nashvillehousing


 
  ALTER TABLE nashvillehousing
 add ownersplitaddress varchar(255);

 update nashvillehousing
 SET ownersplitaddress =  PARSENAME(REPLACE(owneraddress, ',', '.'), 3)

  ALTER TABLE nashvillehousing
 add ownersplitcity varchar(255);

 update nashvillehousing
 SET ownersplitcity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

  ALTER TABLE nashvillehousing
 add ownersplitstate varchar(255);

 update nashvillehousing
 SET ownersplitstate = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)

 select DISTINCT(soldasvacant), COUNT(soldasvacant)
 from [portfolioproject&]..nashvillehousing
 group by soldasvacant
 order by 2

 select soldasvacant,
  CASE when soldasvacant = 'Y' THEN 'Yes'
      when soldasvacant = 'N' THEN 'No'
	  ELSE soldasvacant
	  END
 FROM [portfolioproject&]..nashvillehousing

 UPDATE nashvillehousing
 SET soldasvacant = CASE when soldasvacant = 'Y' THEN 'Yes'
      when soldasvacant = 'N' THEN 'No'
	  ELSE soldasvacant
	  END

 select * 
 from [portfolioproject&]..nashvillehousing

 ALTER TABLE  [portfolioproject&]..nashvillehousing
 DROP COLUMN owneraddress, taxdistrict, propertyaddress

 ALTER TABLE  [portfolioproject&]..nashvillehousing
 DROP COLUMN saledate


