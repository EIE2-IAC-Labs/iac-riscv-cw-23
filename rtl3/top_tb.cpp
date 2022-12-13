#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"

#include "vbuddy.cpp"     // include vbuddy code
#define MAX_SIM_CYC 100000000

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vtop* top = new Vtop;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("top.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("PROJECT: RISC-V");

  // initialize simulation inputs
  top->clk = 1;
  top->TRIGGERSEL = 1;
  top->rst = 1;


   int plot = 0;
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    top->rst = 0;
    top->TRIGGERSEL = 1;

    
    if (plot == 0 && top->a0 != 0) {
       plot = 1;
    }
    
    // plot ROM output and print cycle count
    if (plot >= 1) {
       vbdPlot(int(top->a0), 0, 255);
       plot += 1;
    }
    
    /*
    if (plot > 512) {
      break;
    }
    */

    // 
    // vbdCycle(simcyc+1);

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);                // ... exit if finish OR 'q' pressed
  }

  vbdClose();     // ++++
  tfp->close(); 
  exit(0);
}
