DDR2_CONTROLLER
===============

A controller for DDR2 on FPGA with vhdl, content testbeach, model and textfile-generation/data-detection using python.  
  
file list:  

ddr_control.vhdl----ddr2 controller  
ddr2_m.v----ddr2 model(changing the mecro 2Gbits model to 1Gbits)  
ddr2_parameters.vh----model's head file  
ddr2_sim.vhdl----testbeach  
text.py----generating textfile for testing, using random to make result reliablly  
cmp.py----comparing data writing to ram with data reading from ram  
textfile_st.dat----testing data(address and bank)  
textfile_r.dat----testing data writing to ram(data)  
textfile_w.dat----testing data reading from ram(data)  
license----license  
problem.txt----some problems during sim  

----The wr_num or rd_num must be less than x"0100"----  
----It means Only 1 line would be read/write per operation----  

ddr2_controller----------100%  
testbeach-------------100%  
sim----------------100%
