//+------------------------------------------------------------------+
//|                                                          EMA.mqh |
//|                                      Copyright 2020, PringleCode |
//|                                    https://www.pringlecode.co.uk |
//+------------------------------------------------------------------+
class IndicatorEMA {
public:
   int TimeFrame;
   int Range;
   int MaMethod;
private:
   ENUM_APPLIED_PRICE AppliedPrice;
public:
   IndicatorEMA(void) {};
   ~IndicatorEMA(void) {};
   IndicatorEMA(int timeframe, int period, int method) :
      TimeFrame(timeframe), Range(period), MaMethod(method)  {
      this.AppliedPrice = PRICE_CLOSE;
   }
public:
   double getValue(int bar) {
      return iMA(Symbol(), this.TimeFrame, this.Range, 0, this.MaMethod, this.AppliedPrice, bar);
   }
};

class TripleEMA {
public:
   ENUM_TIMEFRAMES TimeFrame;
   IndicatorEMA fastEMA, slowEMA, linearWMA;
public:
   TripleEMA(void) {};
   ~TripleEMA(void) {};
   TripleEMA(ENUM_TIMEFRAMES timeframe, int fast, int slow, int linear)
      : TimeFrame(timeframe) {
      fastEMA = new IndicatorEMA(timeframe, fast, MODE_EMA);
      slowEMA = new IndicatorEMA(timeframe, slow, MODE_EMA);
      linearWMA = new IndicatorEMA(timeframe, linear, MODE_LWMA);
   }
   bool IsTrending(ENUM_ORDER_TYPE orderType) {
      double FAST = fastEMA.getValue(1);
      double SLOW = slowEMA.getValue(1);
      double LINEAR = linearWMA.getValue(1);
      bool trending_up = FAST > SLOW && SLOW > LINEAR;
      bool trending_down = FAST < SLOW && SLOW < LINEAR;
      return (orderType == OP_BUY && trending_up) || (orderType == OP_SELL && trending_down);
   }
};



TripleEMA tripleEMA;


// You would inlcude the code above as a header then
// your ex4 file would look like the below

#include "EMA.mqh"

input string EMA_SETTINGS; // EMA Settings:
extern int FastEMA = 50; // Fast:
extern int SlowEMA = 100; // Slow:
extern int LinearWMA = 240; // Linear:
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   tripleEMA = TripleEMA(PERIOD_CURRENT, FastEMA, SlowEMA, LinearWMA);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick() {
   if(tripleEMA.IsTrending(OP_BUY)) {
      // check other buy conditions
   } else if(tripleEMA.IsTrending(OP_SELL)) {
      // check other sell conditions
   } else {
      // No trade
   }
}
//+------------------------------------------------------------------+
