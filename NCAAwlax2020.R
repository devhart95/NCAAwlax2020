maryland <- read.csv("Marylandcheck2020.csv")

toDelete <- seq(1, nrow(maryland), 2)
maryland <- maryland[-toDelete,]

stanford <- read.csv("Stanford2020.csv")

toDelete1 <- seq(1, nrow(stanford), 2)
stanford <- stanford[-toDelete1,]

american <- read.csv("AmericanUniversity2020.csv")

toDelete2 <- seq(1, nrow(american), 2)
american <- american[-toDelete2,]

#Test a function
#To Delete empty rows

oldseasons <- function(school){
  toDelete <- seq(1, nrow(school), 2)
  school <- school[-toDelete,]
}

oldseasons(american)
