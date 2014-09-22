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

architecture TESTBEACH of DDR2SIM is

component DDR2_CONTROL is
port
	(
		pll_lock:in std_logic;
		
		clk_control_p,clk_control_n,clk_control_90,clk_control_270:in std_logic;
		clk_data_p:in std_logic;
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
		wr_end,rd_end:out std_logic:='1';
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

component DDR2_M is
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

signal clk_c_0,clk_c_90,clk_c_180,clk_c_270,clk_d_0,pll_lock:std_logic;
signal ddr_clk,ddr_clk_n:std_logic;
signal cke,n_cs,n_ras,n_cas,n_we:std_logic;
signal dm:std_logic_vector(1 downto 0);
signal dqs,dqs_in,dqs_out:std_logic_vector(1 downto 0);
signal dqs_en:std_logic_vector;
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

constant clk_period:time:=6 ns; 
constant clk_period2:time:=3 ns;  
signal clk_self:std_logic;
signal ddr2_data_sim:std_logic_vector(15 downto 0);
signal ddr2_data_text:line 


begin


DDR2C:DDR2_CONTROL
	port map
		(
			pll_lock=>pll_lock,
			clk_control_p=>clk_c_0,clk_control_n=>clk_c_90,clk_control_90=>clk_c_180,clk_control_270=>clk_c_270,
			clk_data_p=>clk_d_0,
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

DDR2M:DDR2_M
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
			odt=>odt
		);

clk_0:process
begin	
	dclk_0<='1';
	
	wait for clk_period/2;
	dclk_0<='0';
	wait for clk_period/2;
end process;

clk_180:process
begin	
	dclk_180<='0';
	wait for clk_period/2;
	dclk_180<='1';
	wait for clk_period/2;
end process;

clk_90:process
begin	
	dclk_90<='1';
	wait for clk_period/4;
	dclk_90<='0';
	wait for clk_period/2;
	dclk_90<='1';
end process;

clk_270:process
begin	
	dclk_270<='0';
	wait for clk_period/4;
	dclk_270<='1';
	wait for clk_period/2;
	dclk_270<='0';
end process;

clk_data_0:process
begin	
	clk_self<='1';
	ddclk_0<='1';
	wait for clk_period2/2;
	clk_self<='0';
	ddclk_0<='0';
	wait for clk_period2/2;
end process;

pll_lock<='1';

process(clk_self)

variable con:integer range 0 to 3:=0;
file ddr2_data_text:text;
variable fst:FILE_OPEN_STATUS; 
variable ddr2_data_line:line; 

begin

	file_open(fst ,ddr2_data_text ,"textfile.txt",read_mode);

	wait for 500 us;
		
	write_num<=x"0200";
	bank<="000";
	addr_col<="0000000000";
	addr_row<="0000000000000";

	if rising_edge(clk_self) then
	
		if con=0 then
			wr_rqu<='0';
			con:=con+1;
		else
			if wr_ready='1' then
				readline(ddr2_data_text,ddr2_data_line); 
				ram_data_out<=ddr2_data_sim;
			end if;
		end if;

	end if;
	file_close(ddr2_data_text);

end process;

end TESTBEACH;