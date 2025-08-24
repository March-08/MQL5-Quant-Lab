# 🔰 Basic MQL5 Strategies

This folder contains fundamental MQL5 Expert Advisors designed for beginners to learn the basics of algorithmic trading and MQL5 programming.

## 📚 Strategies Included

### ⏰ [TimeBasedEA.mq5](./TimeBasedEA.mq5)
**A simple time-based trading strategy for learning MQL5 fundamentals**

**What it does:**
- Opens a BUY position at a specified hour
- Closes the position at another specified hour
- Demonstrates basic EA structure and time management

**Key Learning Points:**
- MQL5 Expert Advisor structure (`OnInit`, `OnTick`, `OnDeinit`)
- Input parameter validation
- Time handling with `MqlDateTime`
- Basic position management
- Alert system usage

**Parameters:**
- `openHour`: Hour to open position (0-23)
- `closeHour`: Hour to close position (0-23)

---

### 📊 [MovingAverageCrossover.mq5](./MovingAverageCrossover.mq5)
**Classic dual moving average crossover strategy for trend identification**

**📈 Complete Strategy Explanation:**

**What are Moving Averages?** Moving averages smooth out price data to identify trend direction. This strategy uses two MAs:
- **Fast MA**: 20-period SMA (reacts quickly to price changes)
- **Slow MA**: 200-period SMA (shows long-term trend)

**Trading Logic:**
1. **Bullish Crossover**: Fast MA crosses ABOVE slow MA → Enter LONG (BUY)
2. **Bearish Crossover**: Fast MA crosses BELOW slow MA → Enter SHORT (SELL)
3. **New Bar Execution**: Only checks for signals when a new bar forms (not on every tick)

**Risk Management:**
- **Fixed Stop Loss**: 100 points from entry price
- **Fixed Take Profit**: 100 points from entry price
- **Magic Number**: 20250824 (to identify this EA's trades)

**Key Learning Points:**
- Moving average indicator integration (`iMA`)
- Crossover detection logic
- New bar detection technique (`static datetime`)
- Market order placement with SL/TP
- Array handling and series ordering
- Professional error handling and logging

**Parameters:**
- Fast MA: 20 periods (customizable in code)
- Slow MA: 200 periods (customizable in code)
- Fixed lot size: 0.01
- SL/TP distance: 100 points

**Use Case:** Perfect introduction to trend-following strategies and indicator-based trading

---

### 📏 [ATRPositionSizing.mq5](./ATRPositionSizing.mq5)
**Advanced ATR-based trading strategy with volatility-adaptive entries**

**📊 Complete Strategy Explanation:**

**What is ATR?** Average True Range (ATR) is an indicator that measures market volatility by calculating the average of the last N candles' true ranges.

**How ATR Behaves:**
- When recent candles are small → ATR value decreases  
- When candles become bigger → ATR value increases
- ATR adapts to current market volatility conditions

**Trading Logic:**
1. **Compare** each candle's size to its corresponding ATR value
2. **Trigger Condition**: When a candle is X times bigger than the ATR value
3. **Entry Direction**: Enter in the direction of the large "trigger candle"
   - Big red candle (bearish) → Enter SHORT
   - Big green candle (bullish) → Enter LONG

**Example:** After a big bearish candle that's significantly larger than ATR, the trend often continues downward, making it a good short entry signal.

**Key Learning Points:**
- Technical indicator integration (ATR calculation)
- Volatility-based entry signals
- Momentum and trend-following concepts
- Dynamic market adaptation
- Professional trading strategy structure

**Parameters:**
- ATR period (N candles for calculation)
- Multiplier threshold (X times ATR)
- Position sizing based on volatility
- Risk management integration

---

## 🎯 How to Use These Strategies

1. **Start with TimeBasedEA**: Learn basic EA structure and MQL5 fundamentals
2. **Progress to MovingAverageCrossover**: Understand indicator integration and trend following
3. **Advance to ATRPositionSizing**: Master volatility-based strategies and risk management
4. **Modify and experiment**: Change parameters to see different behaviors
5. **Test on demo accounts**: Always test before live trading

## 🔧 Installation Instructions

1. Copy the `.mq5` files to your MetaTrader 5 `Experts` folder
2. Compile in MetaEditor (F7)
3. Attach to a chart and configure parameters
4. Enable automated trading

## ⚠️ Important Notes

- These are educational examples - always test thoroughly
- Start with demo accounts
- Understand the code before using with real money
- Modify parameters based on your risk tolerance

## 🚀 Next Steps

After mastering these basics, move on to:
- **02-Standard-Algorithms**: More complex trading strategies
- **03-AI-ML-Strategies**: Machine learning implementations
