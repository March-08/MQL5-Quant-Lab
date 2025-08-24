/*
Script to open and close trade on a certain hour 
*/

#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

input int openHour;
input int closeHour;
bool isTradeOpen = false;
CTrade trade;


//called everytime expert advisor starts
int OnInit()
  {
   //check user input
   if(openHour == closeHour){
      Alert("openHour and closedHout must differ");
      return INIT_PARAMETERS_INCORRECT;
   }
   return(INIT_SUCCEEDED);åå
  }

void OnDeinit(const int reason)
  {

   
  }

//executed everytime a price changes
void OnTick()
  {
      MqlDateTime timeNow;
      TimeToStruct(TimeCurrent(), timeNow);
      
      //check for trade open
      if(openHour == timeNow.hour && !isTradeOpen){
         //open position
         trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, 1, SymbolInfoDouble(_Symbol, SYMBOL_ASK), 0,0);
         
         //set flag
         isTradeOpen = true;
         
      }
      
            
      //check for trade open
      if(closeHour == timeNow.hour && isTradeOpen){
      
         trade.PositionClose(_Symbol);
         
         //set flag
         isTradeOpen = false;
     
         
      }      
 
      
   
  }

