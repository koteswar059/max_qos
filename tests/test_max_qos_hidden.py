from __future__ import annotations

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb_tools.runner import get_runner
import logging

LANGUAGE = os.getenv("HDL_TOPLEVEL_LANG", "verilog").lower().strip()

@cocotb.test()

async def max_qos_simple_test(dut):
   """Test that max qos is calcuated properly using directed test"""

   logger = logging.getLogger("max_qos.log")

   qos_values = []  
   # Set initial input value to prevent it from floating
   dut.rst.value = 1

   dut.wr_vld.value = 0
   dut.wr_id.value = 0
   dut.wr_qos.value = 0

   dut.rd_vld.value = 0
   dut.rd_id.value = 0

   # Create a 10us period clock driver on port `clk`
   clock = Clock(dut.clk, 10, unit="us")
   # Start the clock. Start it low to avoid issues on the first RisingEdge
   clock.start(start_high=False)

   # Synchronize with the clock to de-assert the reset
   await RisingEdge(dut.clk)
   dut.rst.value = 0
   await RisingEdge(dut.clk)

   for i in range(16):
       val = random.randint(0, 7)
       dut.wr_vld.value = 1
       dut.wr_id.value  = i
       dut.wr_qos.value = val  # Assign the random value val to qos
       qos_values.append(val)
       logger.info(f"pushing {val} in {i}")
       await RisingEdge(dut.clk)

   dut.wr_vld.value = 0

   # Read the Ids one by one
   for i in range(16):
       dut.rd_vld.value = 1
       dut.rd_id.value  = i
       await RisingEdge(dut.clk)
       max_qos_out = max(qos_values)
       qos_out = qos_values.pop(0)
       assert qos_out == dut.rd_qos.value, f"qos value is not matching for {i}"
       assert max_qos_out == dut.o_max_qos.value, f"max qos value is not matching for {i}"

   dut.rd_vld.value = 0

   await RisingEdge(dut.clk)

def test_max_qos_hidden_runner():
   sim = os.getenv("SIM", "icarus")

   proj_path = Path(__file__).resolve().parent.parent

   sources = [ proj_path / "sources/max_qos.sv"]

   runner = get_runner(sim)
   runner.build(
       sources=sources,
       hdl_toplevel="max_qos",
       always=True,
       waves=True
   )

   runner.test(hdl_toplevel="max_qos", test_module="test_max_qos_hidden",waves=True)
