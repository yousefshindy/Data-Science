file_path <- "D:/DEBI/UOTTAWA/First Semester/Data Science/Assignments/Assignment 1/customer_churn.csv"

# Read the CSV file
df <- read.csv(file_path)

revenue_cube <- 
  tapply(df$Total.Revenue, 
         df[,c("Contract", "Offer", "Internet.Type", "Customer.Status")], 
         FUN=function(x){return(sum(x))})

two_years = apply(revenue_cube, c("Contract", "Offer" ,"Internet.Type"),
      FUN=function(x) {return(sum(x, na.rm=TRUE))})

two_years["Two Year",,]

total_B_for_churned = sum(revenue_cube[ , "Offer B" ,  ,],na.rm = TRUE)

total_offers = revenue_cube[ "Month-to-Month", "Offer B" , "Cable" ,"Churned"]

total_offers/ total_B_for_churned * 100

