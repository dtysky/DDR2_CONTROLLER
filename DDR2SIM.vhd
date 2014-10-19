library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity DDR2SIM is

end entity;

architecture TESTBENCH of DDR2SIM is

component DDR2_CONTROL is
port
	(
		pll_lock:in std_logic;
		
		clk_control_p,clk_control_n,clk_out_p,clk_out_n:in std_logic;
		clk_data:in std_logic;
		clk,n_clk:out std_logic;
		cke,n_cs,n_ras,n_cas,n_we:out std_logic:='1';
		udm,ldm:out std_logic:='0';
		
		udqs_in,ldqs_in:in std_logic:='1';
		udqs_out,ldqs_out:out std_logic:='1';
		dqs_en:out std_logic:='0';
		
		odt:out std_logic:='0';
		bank:out std_logic_vector(2 downto 0);
		addr:out std_logic_vector(12 downto 0);
		
		ram_data_in:in std_logic_vector(15 downto 0):=x"0000";
		ram_data_out:out std_logic_vector(15 downto 0):=x"0000";
		ram_data_en:out std_logic:='0';
		
		ram_reset:in std_logic:='0';
		
		wr_rqu,rd_rqu:in std_logic:='0';
		wr_ready,rd_ready:out std_logic:='0';
		wr_end,rd_end:out std_logic:='0';
		udm_in,ldm_in:in std_logic:='0';
		write_num:in std_logic_vector(15 downto 0);
		read_num:in std_logic_vector(15 downto 0);
		data_other_in:in std_logic_vector(15 downto 0);
		data_other_out:out std_logic_vector(15 downto 0);
		bank_other:in std_logic_vector(2 downto 0);
		addr_other_row:in std_logic_vector(12 downto 0);
		addr_other_col:in std_logic_vector(9 downto 0)
	);
end component;

component DDR2 is
port
	(
		ck:in std_logic;
		ck_n:in std_logic;
		cke:in std_logic;
		cs_n:in std_logic;
		ras_n:in std_logic;
		cas_n:in std_logic;
		we_n:in std_logic;
		dm_rdqs:inout std_logic_vector(1 downto 0);
		ba:in std_logic_vector(2 downto 0);
		addr:in std_logic_vector(12 downto 0);
		dq:inout std_logic_vector(15 downto 0);
		dqs:inout std_logic_vector(1 downto 0);
		dqs_n:inout std_logic_vector(1 downto 0);
		rdqs_n:out std_logic_vector(1 downto 0);
		odt:in std_logic
	);
end component;

signal clk_c_0,clk_c_90,clk_c_180,clk_c_270,clk_d_0,clk_d_180,pll_lock:std_logic;
signal ddr_clk,ddr_clk_n:std_logic;
signal cke,n_cs,n_ras,n_cas,n_we:std_logic;
signal dm:std_logic_vector(1 downto 0);
signal dqs,dqs_in,dqs_out:std_logic_vector(1 downto 0);
signal dqs_en:std_logic;
signal odt:std_logic;
signal bank:std_logic_vector(2 downto 0);
signal addr:std_logic_vector(12 downto 0);
signal data,data_in,data_out:std_logic_vector(15 downto 0);
signal data_en:std_logic;
signal ram_reset:std_logic;
signal wr_rqu,rd_rqu:std_logic;
signal wr_ready,rd_ready:std_logic;
signal wr_end,rd_end:std_logic;
signal ot_dm:std_logic_vector(1 downto 0);
signal wr_num,rd_num:std_logic_vector(15 downto 0);
signal ot_data_in,ot_data_out:std_logic_vector(15 downto 0);
signal ot_bank:std_logic_vector(2 downto 0);
signal ot_addr_row:std_logic_vector(12 downto 0);
signal ot_addr_col:std_logic_vector(9 downto 0);
signal dqs_n,rdqs_n:std_logic_vector(1 downto 0);

constant clk_period:time:=6000 ps; 
constant clk_period2:time:=3000 ps;  
signal clk_self:std_logic;


begin


DDR2C:DDR2_CONTROL
	port map
		(
			pll_lock=>pll_lock,
			clk_control_p=>clk_c_0,clk_control_n=>clk_c_180,clk_out_p=>clk_c_0,clk_out_n=>clk_c_180,
			clk_data=>clk_d_0,
			clk=>ddr_clk,n_clk=>ddr_clk_n,
			cke=>cke,n_cs=>n_cs,n_ras=>n_ras,n_cas=>n_cas,n_we=>n_we,
			udm=>dm(1),ldm=>dm(0),
			
			udqs_in=>dqs_in(1),ldqs_in=>dqs_in(0),
			udqs_out=>dqs_out(1),ldqs_out=>dqs_out(0),
			dqs_en=>dqs_en,
			odt=>odt,
			bank=>bank,addr=>addr,
			
			ram_data_in=>data_in(15 downto 0),
			ram_data_out=>data_out(15 downto 0),
			ram_data_en=>data_en,
			
			ram_reset=>ram_reset,
			
			wr_rqu=>wr_rqu,rd_rqu=>rd_rqu,
			wr_ready=>wr_ready,rd_ready=>rd_ready,
			wr_end=>wr_end,rd_end=>rd_end,
			udm_in=>ot_dm(1),ldm_in=>ot_dm(0),
			write_num=>wr_num,read_num=>rd_num,
			bank_other=>ot_bank,
			addr_other_row=>ot_addr_row,
			addr_other_col=>ot_addr_col,
			data_other_in=>ot_data_in,
			data_other_out=>ot_data_out
		);

DDR2M:DDR2
	port map
		(
			ck=>ddr_clk,
			ck_n=>ddr_clk_n,
			cke=>cke,
			cs_n=>n_cs,
			ras_n=>n_ras,
			cas_n=>n_cas,
			we_n=>n_we,
			dm_rdqs=>dm,
			ba=>bank,
			addr=>addr,
			dq=>data,
			dqs=>dqs,
			dqs_n=>dqs_n,
			rdqs_n=>rdqs_n,
			odt=>odt
		);

clk_0:process
begin	
	clk_c_0<='1';
	wait for clk_period/2;
	clk_c_0<='0';
	wait for clk_period/2;
end process;

clk_180:process
begin	
	clk_c_180<='0';
	wait for clk_period/2;
	clk_c_180<='1';
	wait for clk_period/2;
end process;

clk_90:process
begin	
	wait for clk_period/4;
	clk_c_90<='0';
	wait for clk_period/2;
	clk_c_90<='1';
	wait for clk_period/4;
end process;

clk_270:process
begin	
	wait for clk_period/4;
	clk_c_270<='1';
	wait for clk_period/2;
	clk_c_270<='0';
	wait for clk_period/4;
end process;

clk_data_0:process
begin	
	clk_d_0<='1';
	clk_self<='1';
	wait for clk_period2/2;
	clk_d_0<='0';
	clk_self<='0';
	wait for clk_period2/2;
end process;

clk_data_180:process
begin	
	clk_d_180<='0';
	wait for clk_period2/2;
	clk_d_180<='1';
	wait for clk_period2/2;
end process;

pll_lock<='1';
with dqs_en select
	dqs(1) <= dqs_out(1) when '1',
			  'Z' when others;
dqs_in(1)<=dqs(1);
with dqs_en select
	dqs(0) <= dqs_out(0) when '1',
			  'Z' when others;
dqs_in(0)<=dqs(0);

with data_en select
	data <= data_out when '1',
					"ZZZZZZZZZZZZZZZZ" when others;
data_in<=data;

main:process

file ddr2_data_text_w,ddr2_data_text_r,ddr2_data_text_st:text;
variable fstin,fstout,fstst:FILE_OPEN_STATUS; 
variable ddr2_data_line:line; 
variable ddr2_data_sim:std_logic_vector(15 downto 0);
variable ddr2_row_sim:std_logic_vector(12 downto 0);
variable ddr2_col_sim:std_logic_vector(9 downto 0);
variable ddr2_bank_sim:std_logic_vector(2 downto 0);
variable con:integer range 0 to 7:=0;

begin
	file_open(fstst ,ddr2_data_text_st ,"textfile_st.dat",read_mode);
	file_open(fstin ,ddr2_data_text_r ,"textfile_r.dat",read_mode);
	file_open(fstout ,ddr2_data_text_w ,"textfile_w.dat",write_mode);
	while (con<6) loop 
		wait until rising_edge(clk_self); --每个时钟读一行
		--------write--------
		if con=0 then
			if not endfile(ddr2_data_text_st) then
				ot_dm<="00";
				wr_num<=x"0080";
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_bank_sim);
				ot_bank<=ddr2_bank_sim;
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_col_sim);
				ot_addr_col<=ddr2_col_sim;
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_row_sim);
				ot_addr_row<=ddr2_row_sim;
				wr_rqu<='1';
				con:=con+1;
			else
				file_close(ddr2_data_text_st);
				file_open(fstst ,ddr2_data_text_st ,"textfile_st.dat",read_mode);
				con:=3;
			end if;
		elsif con=1 then
			if wr_ready='1' then
				readline(ddr2_data_text_r,ddr2_data_line); 
				read(ddr2_data_line,ddr2_data_sim);
				if ddr2_data_sim=x"FFFF" then
					con:=con+1;
				else
					ot_data_in<=ddr2_data_sim;
				end if;
			end if;
		elsif con=2 then
			if wr_end='1' then
				wr_rqu<='0';
				con:=0;
			end if;
		--------read--------
		elsif con=3 then
			if not endfile(ddr2_data_text_st) then
				ot_dm<="00";
				rd_num<=x"0080";
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_bank_sim);
				ot_bank<=ddr2_bank_sim;
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_col_sim);
				ot_addr_col<=ddr2_col_sim;
				readline(ddr2_data_text_st,ddr2_data_line); 
				read(ddr2_data_line,ddr2_row_sim);
				ot_addr_row<=ddr2_row_sim;
				rd_rqu<='1';
				con:=con+1;
			else
				con:=6;
			end if;
		elsif con=4 then
			if rd_ready='1' then
				ddr2_data_sim:=ot_data_out;
				write(ddr2_data_line,ddr2_data_sim);
				writeline(ddr2_data_text_w,ddr2_data_line); 
				con:=5;
			end if;
		elsif con=5 then
			if rd_ready='1' then
				ddr2_data_sim:=ot_data_out;
				if ddr2_data_sim="ZZZZZZZZZZZZZZZZ" or ddr2_data_sim="XXXXXXXXXXXXXXXX" then
					null;
				else
					write(ddr2_data_line,ddr2_data_sim);
					writeline(ddr2_data_text_w,ddr2_data_line); 
				end if;
			elsif rd_end='1' then
				rd_rqu<='0';
				con:=3;
			end if;
		end if;			
	end loop;
	file_close(ddr2_data_text_st);
	file_close(ddr2_data_text_r);
	file_close(ddr2_data_text_w);
	wait;


end process;


end TESTBENCH;