

### Using the Census API
# 
# Once we have our map, we can now pull in the census data:
# 
# **CENSUS API PAGE**
# 
# http://www.census.gov/data/developers/data-sets.html
# 
# 
# 
# **REQUEST A KEY**
# 
# http://api.census.gov/data/key_signup.html


# quick change

library(RCurl)
library( jsonlite )



### RUN THIS FUNCTION FIRST - translates json format to data frame format

json.to.data <- function( x )
{
  a.matrix <- fromJSON(x)  # converts json table to a matrix

	c.names <- a.matrix[ 1 , ]  # column names are the first row

	a.matrix <- a.matrix[ -1 , ]

	my.dat <- data.frame( a.matrix, stringsAsFactors=F )

	names( my.dat ) <- c.names
	
	# my.dat[,1] <- as.numeric( as.character( my.dat[,1] ) )

	# > names( my.dat )
	# [1] "DP03_0119PE" "state"       "county"      "tract"
	
	return( my.dat )
}





### GRAB CENSUS DATA
#
# http://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html
#
# API structure
#
# http://api.census.gov/data/2013/acs5?get=NAME,B01001_001E&for=tract:*&in=state:01&key=YOUR_KEY_GOES_HERE




fieldnm <- "DP03_0119PE" # poverty
state <- "36"   # NY
county <- "067"   # Onondaga County
APIkey <- "" # your key here    





### Fetch the data

# household income: B19001_001E
# poverty rate: DP03_0119PE
# total pop: DP05_0028E
# pop black: DP05_0033E



## HOUSEHOLD INCOME

fieldnm <- "B19001_001E" # hh.income

resURL <-  paste("http://api.census.gov/data/2013/acs5/profile/?get=",fieldnm,
               "&for=tract:*&in=state:",state,"+county:",county,"&key=",
               APIkey,sep="")

income.json <- getURL( resURL, ssl.verifypeer = FALSE )

hh.income <- json.to.data( income.json )


# > names( income )
# [1] "B19001_001E" "state"       "county"      "tract"







## POVERTY RATE

fieldnm <- "DP03_0119PE" # poverty

resURL <-  paste("http://api.census.gov/data/2013/acs5/profile/?get=",fieldnm,
               "&for=tract:*&in=state:",state,"+county:",county,"&key=",
               APIkey,sep="")

poverty.json <- getURL( resURL, ssl.verifypeer = FALSE )

poverty <- json.to.data( poverty.json )

# > names( poverty )
# [1] "DP03_0119PE" "state"       "county"      "tract"







## BLACK

fieldnm <- "DP05_0033E" # black

resURL <-  paste("http://api.census.gov/data/2013/acs5/profile/?get=",fieldnm,
               "&for=tract:*&in=state:",state,"+county:",county,"&key=",
               APIkey,sep="")
               
black <- getURL( resURL, ssl.verifypeer = FALSE )

black <- json.to.data( black )





## TOTAL POP

fieldnm <- "DP05_0028E" # tot.pop

resURL <-  paste("http://api.census.gov/data/2013/acs5/profile/?get=",fieldnm,
               "&for=tract:*&in=state:",state,"+county:",county,"&key=",
               APIkey,sep="")
               
tot.pop <- getURL( resURL, ssl.verifypeer = FALSE )

tot.pop <- json.to.data(tot.pop)






prop.black <- as.numeric(black$DP05_0033E) / as.numeric(tot.pop$DP05_0028E)

poverty <- poverty$DP03_0119PE

income <- hh.income$B19001_001E

census.dat <- cbind( hh.income, poverty, prop.black  )


head( census.dat )
