#Roda o pacote RJSON, se n?o estiver instalado, instala primeiro.
if(class(try(library(rjson), silent = T)) == "try-error"){
  install.packages(rjson)
  library(rjson)
}

##Retorna TICKER da API Bitfinex e formata em linha
get_data <- function(symbol){
  
  #get data from ticker API
  ticker <- fromJSON(file = paste("https://api.bitfinex.com/v1/pubticker/", 
                                  symbol, sep = ""))
  #get data from orderbook API
  orderbook <- fromJSON(file = paste("https://api.bitfinex.com/v1/book/", 
                                     symbol, "?&limit_bids=10000&limit_asks=10000", sep = ""))
  
  #Turn orderobook$bids into dataframe
  bid <- unlist(orderbook$bids)
  bids <- cbind(Price = as.numeric(bid[names(bid)=="price"]), 
                Amount = as.numeric(bid[names(bid)=="amount"]))
  bids <- as.data.frame(bids, stringAsFactors = F)
  
  #Turn orderobook$asks into dataframe
  ask <- unlist(orderbook$asks)
  asks <- cbind(Price = as.numeric(ask[names(ask)=="price"]), 
                Amount = as.numeric(ask[names(ask)=="amount"]))
  asks <- as.data.frame(asks, stringAsFactors = F)
  
  #Create line combining data
  Bbx <- boxplot(bids$Price, plot = F)
  Abx <- boxplot(asks$Price, plot = F)
  line <- c("AIL" = Abx$stats[1], 
            "AQ1" = Abx$stats[2], 
            "AMD" = Abx$stats[3], 
            "AQ3" = Abx$stats[4], 
            "ASL" = Abx$stats[5], 
            "BIL" = Bbx$stats[1], 
            "BQ1" = Bbx$stats[2], 
            "BMD" = Bbx$stats[3], 
            "BQ3" = Bbx$stats[4], 
            "BSL" = Bbx$stats[5],
            "BAMOUNT" = sum(bids$Amount), 
            "AAMOUNT" = sum(asks$Amount),
            "Bid" = as.numeric(ticker$bid), 
            "Ask" = as.numeric(ticker$ask), 
            "Last" = as.numeric(ticker$last_price), 
            "Low" = as.numeric(ticker$low), 
            "High" = as.numeric(ticker$high), 
            "Volume" = as.numeric(ticker$volume), 
            "Timestamp" = as.numeric(ticker$timestamp)
            )
  #Returns line with combined data
  return(line)
}
