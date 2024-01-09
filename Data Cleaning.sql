
--Cleaning data in SQL Querries


SELECT *
 FROM [PortfolioProject].[dbo].[NashvilleHousing]


                                                       --standardize sale date
  SELECT SalesDateConverted
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add SalesDateConverted Date

update [PortfolioProject].[dbo].[NashvilleHousing]
set SalesDateConverted=convert(date,SaleDate)

  
  
                                                       --populate property address data


    SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject..NashvilleHOusing a
  join PortfolioProject..NashvilleHOusing b
  on a.ParcelID=b.ParcelID
  and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null


update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject..NashvilleHOusing a
  join PortfolioProject..NashvilleHOusing b
  on a.ParcelID=b.ParcelID
  and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null


                                                     --'breaking out Address into Individual Columns(Address,City,State)
Select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from [PortfolioProject].[dbo].[NashvilleHousing]


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitAddress Nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitAddress=substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitCity Nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))


select *
from [PortfolioProject].[dbo].[NashvilleHousing]



                                                          --simpler way to split text than above
select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitAddress Nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitAddress=parsename(replace(OwnerAddress,',','.'),3)

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitCity Nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitCity=parsename(replace(OwnerAddress,',','.'),2)

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitState Nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitState=parsename(replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject..NashvilleHousing



                                                        --change Y and N to Yes and No in "Sold as Vacant"

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant


select 
SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant=case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
	   

	                                              --Remove Duplicates

with RowNumCTE as(
select *,
row_number()over(
partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num>1


                                                 --Delete Unused Columns

select *
from PortfolioProject..NashvilleHousing


alter table  PortfolioProject..NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate