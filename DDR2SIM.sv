module  ddr2sim();

	//Parameter
	timeunit 1ps;
	timeprecision 1ps;
	parameter Ram_bank_l=3;
	parameter Ram_addr_row_l=13;
	parameter Ram_addr_col_l=10;
	parameter Ram_data_l=16;

	//Class
	class ram_class;
		rand bit[Ram_bank_l-1:0] bank;
		rand bit[Ram_addr_row_l-1:0] addr_row;
		rand bit[Ram_addr_col_l-1:0] addr_col;
		rand bit[15:0] nums;
		rand int reset_delay;
		rand bit reset_en;
		bit[Ram_data_l-1:0] data[$],r_data[$];
		bit[Ram_data_l-1:0] ram_model[2**Ram_bank_l-1][2**Ram_addr_row_l-1][2**Ram_addr_col_l-1];
		bit[Ram_bank_l-1:0] r_bank[$];
		bit[Ram_addr_row_l-1:0] r_addr_row[$];
		bit[Ram_addr_col_l-1:0] r_addr_col[$];
		bit[15:0] r_nums[$];
		constraint c_num{
			nums<16'h100;
			reset_delay<1000;
		}

		function new();
			foreach(ram_model[i,j,k])
				ram_model[i][j][k]=$urandom_range(0,16'hffff);
		endfunction : new

		function void write_creat();
			this.randomize();
			data.delete();
			for (int i=0;i<nums*4;i++)
				data.push_back(ram_model[bank][addr_row][addr_col+i]);
			if (reset_en!=1)
				r_nums.push_back(nums);
				r_bank.push_back(bank);
				r_addr_row.push_back(addr_row);
				r_addr_col.push_back(addr_col);
		endfunction : write_creat

		function bit[15:0] data_write(integer i);
			return data[i];
		endfunction : data_write

		function void read_creat();
			int i=$urandom_range(0,$size(r_bank));
			nums=r_nums[i];
			bank=r_bank[i];
			addr_row=addr_row[i];
			addr_col=addr_col[i];
			r_data.delete();
		endfunction : read_creat

		function void data_read(bit[15:0] data_in);
			r_data.push_back(data_in);
		endfunction : data_read

		function void check();
			for (int i=0;i<nums;i++)
				if (ram_model[bank][addr_row][addr_col+i]!=r_data.pop_front())
					$fatal("Error!");
		endfunction : check

	endclass : ram_class


	//Signal
	bit clk_c_0,clk_c_180,clk_o_0,clk_o_180,clk_d_0,clk_d_180,pll_lock;
	bit ddr2_clk,ddr2_clk_n;
	bit cke,n_cs,n_ras,n_cas,n_we;
	wire[1:0] dm;
	bit[1:0] dqs_in,dqs_out;
	wire[1:0] dqs;
	bit dqs_en;
	bit odt;
	bit[2:0] bank;
	bit[12:0] addr;
	bit[15:0] data_in,data_out;
	wire[15:0] data;
	bit data_en;
	bit ram_reset;
	bit wr_rqu,rd_rqu;
	bit wr_ready,rd_ready;
	bit wr_end,rd_end;
	bit[1:0] ot_dm;
	bit[15:0] wr_num,rd_num;
	bit[15:0] ot_data_in,ot_data_out;
	bit[2:0] ot_bank;
	bit[12:0] ot_addr_row;
	bit[9:0] ot_addr_col;
	wire[1:0] dqs_n,rdqs_n;
	//Class
	ram_class ram_c;

	//Instantiation
	CLOCK clk(
		clk_c_0,clk_c_180,
		clk_o_0,clk_o_180,
		clk_d_0,clk_d_180,
		pll_lock
		);

	DDR2_CONTROL DDR2C(
		pll_lock,clk_c_0,clk_c_180,clk_o_0,clk_o_180,clk_d_0,
		ddr2_clk,ddr2_clk_n,cke,n_cs,n_ras,n_cas,n_we,
		dm[1],dm[0],
		dqs_in[1],dqs_in[0],dqs_out[1],dqs_out[0],dqs_en,
		odt,bank,addr,data_in,data_out,data_en,
		ram_reset,
		wr_rqu,rd_rqu,wr_ready,rd_ready,wr_end,rd_end,
		ot_dm[1],ot_dm[0],
		wr_num,rd_num,
		ot_data_in,ot_data_out,ot_bank,ot_addr_row,ot_addr_col
		);

	ddr2 DDR2M(
		ddr2_clk,ddr2_clk_n,
		cke,n_cs,n_ras,n_cas,n_we,
		dm,
		bank,addr,
		data,dqs,dqs_n,rdqs_n,
		odt
		);

	//Wire
	assign dqs=dqs_en?(dqs_out):2'bz;
	assign data=data_en?(data_out):16'bz;
	assign dqs_in=dqs;
	assign data_in=data;

	//Task
	task write();
		@(posedge clk_d_180);
		ram_c.write_creat();
		ot_dm=2'b0;
		wr_num=ram_c.nums;
		ot_bank=ram_c.bank;
		ot_addr_row=ram_c.addr_row;
		ot_addr_col=ram_c.addr_col;
		wr_rqu=1;
		while(!wr_ready) @(posedge clk_d_180);
		ot_data_in=ram_c.data_write(0);
		for(int i=1;i<ram_c.nums*4;i++) @(posedge clk_d_180)
			ot_data_in=ram_c.data_write(i);
		while(!wr_end) @(posedge clk_d_180);
		wr_rqu=0;
		return;
	
	endtask : write

	task read();
		@(posedge clk_d_180);
		ram_c.read_creat();
		wr_num=ram_c.nums;
		ot_bank=ram_c.bank;
		ot_addr_row=ram_c.addr_row;
		ot_addr_col=ram_c.addr_col;
		rd_rqu=1;
		while(!rd_ready) @(posedge clk_d_180);
		ram_c.data_read(ot_data_out);
		repeat(ram_c.nums*4-1) @(posedge clk_d_180)
			ram_c.data_read(ot_data_out);
		while(!rd_end) @(posedge clk_d_180);
		rd_rqu=0;
		return;
	endtask : read

	//Init
	initial begin
		ram_c=new();
		repeat(100)
			write();
		repeat(100) begin
			read();
			ram_c.check();
		end
	end


endmodule

