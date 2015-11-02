


###  CHOROPLETH MAP EXAMPLE








# STEP 1:

# we are using the maps() package here so no tiger shapefiles necessary

library( maps )




# STEP 2: 

# also cheating here by using a built-in dataset


data( unemp )

data( county.fips ) # dataset associated with maps package - needed for join





# STEP 3: assign a color to each level of unemployment, red = high, gray = medium, blue = low

color.function <- colorRampPalette( c("steel blue","light gray","firebrick4" ) )

col.ramp <- color.function( 5 ) # number of groups you desire





# STEP 4: create the levels of data

color.vector <- cut( rank(unemp$unemp), breaks=5, labels=col.ramp )

color.vector <- as.character( color.vector )




# STEP 5: match the correct levels to the proper counties

this.order <- match( county.fips$fips, unemp$fips )

color.vec.ordered <- color.vector[ this.order ]





# STEP 6: draw the map

map( database="county", col=color.vec.ordered, fill=T, lty=0 )




# STEP 7: add the map bling

title( main="Unemployment Levels by County in 2009")

map.scale( metric=F, ratio=F, relwidth = 0.15, cex=0.5 )

legend.text=c(" 0-4 %"," 4-8 %"," 8-12 %","12-21 %","21-96 %")

legend( "bottomright", bg="white",
        pch=19, pt.cex=1.5, cex=0.7,
        legend=legend.text, 
        col=col.ramp, 
        box.col="white",
        title="Poverty Rate" 
       )

