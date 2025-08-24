//+------------------------------------------------------------------+
//|         Simple MA Crossover – commented for beginners            |
//|  Idea: create a fast & slow moving average; trade on crossovers  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>   // CTrade helper to place/modify orders

CTrade trade; // one global trade object(used to send orders)

//--- Runs once when the EA starts (load magic number, etc. if you want)
int OnInit()
{
   // Optional: tag this EA’s trades with a magic number so you can filter them later
    trade.SetExpertMagicNumber(20250824);
    return(INIT_SUCCEEDED);
}

//--- Runs once when EA is removed (nothing to clean up here)
void OnDeinit(const int reason)
{
}

//--- Main function: MT5 calls this on every price update (every tick)
void OnTick()
{
   // =============== 1) Work only once per NEW BAR ==================
   // We detect a new bar by comparing current bar's open time to the last seen time.
    static datetime last_bar_time = 0;
    datetime cur_bar_time = iTime(_Symbol, PERIOD_CURRENT, 0); // time of the * current / forming * bar
    if(last_bar_time == cur_bar_time)
    return; // same bar → do nothing; wait for a new bar

    last_bar_time = cur_bar_time; // first tick of a NEW bar → proceed

   // =============== 2) Build MA indicator handles (once) ==========
   // "static" inside the function: created the first time only, reused afterwards.
   // Slow MA = 200 SMA on closing prices (classic long-term trend filter)
    static int handleSlowMA = iMA(_Symbol, PERIOD_CURRENT, 200, 0, MODE_SMA, PRICE_CLOSE);
   // Fast MA = 20 SMA on closing prices (shorter-term trend)
    static int handleFastMA = iMA(_Symbol, PERIOD_CURRENT, 20, 0, MODE_SMA, PRICE_CLOSE);

   // =============== 3) Read the last TWO CLOSED values of each MA ==
   // We read shifts 1 and 2 (bar just closed, and the one before it).
   // Tip: set arrays as “series” so index 0 = most recent item we asked for.
    double slowMaArr[2];
    double fastMaArr[2];
    ArraySetAsSeries(slowMaArr, true);
    ArraySetAsSeries(fastMaArr, true);

   // CopyBuffer(handle, buffer_index, start_shift, count, dest_array)
   // start_shift=1 → last closed bar, count=2 → we get shifts [1] and [2]
   // Return value is how many elements were actually copied → always check!
    if(CopyBuffer(handleSlowMA, 0, 1, 2, slowMaArr) != 2) return;
    if(CopyBuffer(handleFastMA, 0, 1, 2, fastMaArr) != 2) return;

   // Now (because arrays are "series"):
   // slowMaArr[0] = slow MA at bar-1 (just closed)
   // slowMaArr[1] = slow MA at bar-2
   // fastMaArr[0] = fast MA at bar-1
   // fastMaArr[1] = fast MA at bar-2

   // =============== 4) Define the crossover conditions ============
   // Bullish cross (fast crosses UP through slow) between the last two CLOSED bars:
    bool bullish_cross =
    (fastMaArr[0] > slowMaArr[0]) && // now fast above slow
    (fastMaArr[1] <= slowMaArr[1]); // previously fast at / below slow

   // Bearish cross (fast crosses DOWN through slow):
    bool bearish_cross =
    (fastMaArr[0] < slowMaArr[0]) && // now fast below slow
    (fastMaArr[1] >= slowMaArr[1]); // previously fast at / above slow

   // =============== 5) Prepare order parameters ====================
   // _Point = symbol’s smallest price increment (NOT always a pip).
   // _Digits = number of decimals for this symbol (used for rounding).
    double point = _Point;

   // For market orders, you can pass price=0.0 and MT5 will fill at current price
   // which avoids "invalid price" errors if price moves between lines.
    double lots = 0.01; // fixed lot size for the example
    int dist = 100; // SL / TP distance in * points * (example: 100)
   // (for EURUSD 5-digit, 100 points = 10 pips)

   // =============== 6) Place orders on signals =====================
    if(bullish_cross)
    {
      // BUY: SL below, TP above
        double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double sl = NormalizeDouble(ask - dist * point, _Digits);
        double tp = NormalizeDouble(ask + dist * point, _Digits);

      // Tip: you can also enforce broker stop distance if needed.

      // Place a market BUY.
      // (Using 0.0 as price lets the server use the current market price.)
        bool ok = trade.Buy(lots, _Symbol, 0.0, sl, tp, "MA cross BUY");
        if(!ok) Print("Buy failed. Retcode = ", trade.ResultRetcode(), " desc = ", trade.ResultRetcodeDescription());
    }

    if(bearish_cross)
    {
      // SELL: SL above, TP below
        double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        double sl = NormalizeDouble(bid + dist * point, _Digits);
        double tp = NormalizeDouble(bid - dist * point, _Digits);

      // Place a market SELL (note: SELL, not BUY).
        bool ok = trade.Sell(lots, _Symbol, 0.0, sl, tp, "MA cross SELL");
        if(!ok) Print("Sell failed. Retcode = ", trade.ResultRetcode(), " desc = ", trade.ResultRetcodeDescription());
    }
}
