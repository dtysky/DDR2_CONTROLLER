module  test();
	timeunit 1ns;
	timeprecision 1ps;
	parameter Cycle = 20;
	parameter Ram_bank_l=3;
	parameter Ram_addr_row_l=13;
	parameter Ram_addr_col_l=10;
	parameter Ram_data_l=16;

	logic clk;

	class ram_class;
		rand bit[Ram_bank_l:0] bank;
		rand bit[Ram_addr_row_l:0] addr_row;
		rand bit[Ram_addr_col_l:0] addr_col;
		rand bit[15:0] nums;
		rand int reset_delay;
		rand bit reset_en;
		bit[15:0] data[$],r_data[$];
		bit[Ram_data_l:0] ram_model[Ram_bank_l:0][Ram_addr_row_l:0][Ram_addr_col_l:0];
		bit[Ram_bank_l:0] r_bank[$];
		bit[Ram_addr_row_l:0] r_addr_row[$];
		bit[Ram_addr_col_l:0] r_addr_col[$];
		bit[15:0] r_nums[$];
		constraint c_num{
			ram_p.nums<16'h100;
			ram_p.delay<1000;
		}

		function new();
			foreach(ram_model[i,j,k])
				ram_model[i][j][k]=$urandom_range(0,16'hffff);
		endfunction : new

		function write_creat(ref bit[15:0] data[$]);
			this.randomize();
			data.delete();
			for (int i=0;i<nums;i++)
				data.push_back(ram_model[bank][addr_row][addr_col+i]);
			if (reset_en!=1)
				r_nums.push_back(nums);
				r_bank.push_back(bank);
				r_addr_row.push_back(addr_row);
				r_addr_col.push_back(addr_col);
		endfunction : write_creat

		function bit[15:0] data_write();
			return data.pop_front();
		endfunction : data_write

		function read_creat();
			int i=$urandom_range(0,$size(r_bank));
			nums=r_nums[i];
			bank=r_bank[i];
			addr_row=addr_row[i];
			addr_col=addr_col[i];
			r_data.delete();
		endfunction : read_creat

		function data_read(bit[15:0] data_in);
			r_data.push_back(data_in);
		endfunction : data_read

		function check();
			for (int i=0;i<nums;i++)
				if (ram_model[bank][addr_row][addr_col+i]!=r_data.pop_front())
					$fatal("Error!");
		endfunction : check

	endclass : ram_class

	ram_class ram_c;

	initial begin
		clk = 0;
		ram_c = new();
		forever # (Cycle/2) clk=~clk;
	end


endmodule

