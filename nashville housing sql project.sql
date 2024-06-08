select *
from [portfolioproject].[dbo].[nashvillehousing]

--standarize date format

select SaleDate, CONVERT(Date,SaleDate)
from [portfolioproject].[dbo].[nashvillehousing]


--update nashvillehousing
--set SaleDate = CONVERT(Date,SaleDate)

Alter table [portfolioproject].[dbo].[nashvillehousing]
add Saledateconverted date  

update [portfolioproject].[dbo].[nashvillehousing]
set SaleDateconverted = CONVERT(date,SaleDate)

select SaleDateconverted
from [portfolioproject].[dbo].[nashvillehousing]

-- populate property address
select * 
from [portfolioproject].[dbo].[nashvillehousing]

select a.uniqueid , b.uniqueid, a.ParcelID , b.ParcelID ,a.PropertyAddress , b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolioproject].[dbo].[nashvillehousing] a
join [portfolioproject].[dbo].[nashvillehousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolioproject].[dbo].[nashvillehousing] a
join [portfolioproject].[dbo].[nashvillehousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


select *
from [portfolioproject].[dbo].[nashvillehousing]


--breaking out address into columns

select PropertyAddress, substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)
from [portfolioproject].[dbo].[nashvillehousing]


select PropertyAddress , substring(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1, 30) 
from [portfolioproject].[dbo].[nashvillehousing]

select PropertyAddress , substring(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1, len(propertyaddress))
from [portfolioproject].[dbo].[nashvillehousing]

alter table [portfolioproject].[dbo].[nashvillehousing]
add property_address nvarchar(255)

update [portfolioproject].[dbo].[nashvillehousing]
set property_address = substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)


alter table [portfolioproject].[dbo].[nashvillehousing]
add city nvarchar(255)

update [portfolioproject].[dbo].[nashvillehousing]
set city = substring(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1, len(propertyaddress))

select *
from [portfolioproject].[dbo].[nashvillehousing]


--separate ownername into columns

select owneraddress
from [portfolioproject].[dbo].[nashvillehousing]


select PARSENAME(replace(owneraddress,',','.'),1)
from [portfolioproject].[dbo].[nashvillehousing]


select PARSENAME(replace(owneraddress,',','.'),2)
from [portfolioproject].[dbo].[nashvillehousing]


select PARSENAME(replace(owneraddress,',','.'),3)
from [portfolioproject].[dbo].[nashvillehousing]

alter table [portfolioproject].[dbo].[nashvillehousing]
add owner_address nvarchar(255)


update [portfolioproject].[dbo].[nashvillehousing]
set owner_address = PARSENAME(replace(owneraddress,',','.'),3)


alter table [portfolioproject].[dbo].[nashvillehousing]
add owner_city nvarchar(255)


update [portfolioproject].[dbo].[nashvillehousing]
set owner_city = PARSENAME(replace(owneraddress,',','.'),2)


alter table [portfolioproject].[dbo].[nashvillehousing]
add owner_state nvarchar(255)


update [portfolioproject].[dbo].[nashvillehousing]
set owner_state = PARSENAME(replace(owneraddress,',','.'),1)

select * 
from [portfolioproject].[dbo].[nashvillehousing]


-- change y & N to Yes & No in 'sold as vacant'

select distinct(SoldAsVacant) ,count(soldasvacant)
from [portfolioproject].[dbo].[nashvillehousing]
group by SoldAsVacant
order by 2 

select *,
CASE

when SoldAsVacant ='y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from [portfolioproject].[dbo].[nashvillehousing]

update [portfolioproject].[dbo].[nashvillehousing]
set SoldAsVacant = CASE

when SoldAsVacant ='y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

--remove duplicates

with row_num_cte as(
select *,ROW_NUMBER() over (partition by parcelid ,
                                        propertyaddress,
										saleprice,
										saledate,
										legalreference 
										order by uniqueid ) 
										row_num

from [portfolioproject].[dbo].[nashvillehousing]
)

select *
from row_num_cte
where row_num >1

Delete 
from row_num_cte
where row_num >1

--delete unused columns

alter table [portfolioproject].[dbo].[nashvillehousing]
drop column taxdistrict ,SaleDate,PropertyAddress,OwnerAddress