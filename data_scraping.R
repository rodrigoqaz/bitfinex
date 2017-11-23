setwd("c:/R")
require(RODBC)
source("functions.R")

con <- odbcDriverConnect("Driver={SQL Server};Server=cryptobd.database.windows.net;Uid=cryptoadmin;Pwd=@dafn0as99AS;database=bd-crypto")

tryCatch(
{
  #Consulta Bitfinex
  dado <- get_data("btcusd")
  #Insere no banco de dados
  query <- paste("INSERT INTO [dbo].[tbTicker] VALUES ('btcusd',",paste(dado, collapse = ","),")",sep = "")
  sqlQuery(con, query)
}, 
  error = function(e){cat(paste(Sys.time()," - Erro:", sep = ""),conditionMessage(e), "\n", file = "error-log.txt", append = TRUE)}
)

