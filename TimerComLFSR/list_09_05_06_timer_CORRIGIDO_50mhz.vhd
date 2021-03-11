--=============================
-- Listing 9.5 timer
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity timer is
   port(
      clk, reset: in std_logic;
		secU, secT: out std_logic_vector(3 downto 0);
      minU, minT: out std_logic_vector(3 downto 0)
   );
end timer;

-- architecture multi_clock_arch of timer is
--    signal r_reg: unsigned(25 downto 0);
--    signal r_next: unsigned(25 downto 0);
--    signal s_reg, m_reg: unsigned(5 downto 0);
--    signal s_next, m_next: unsigned(5 downto 0);
--    signal sclk, mclk: std_logic;
-- begin
--    -- register
--    process(clk,reset)
--    begin
--       if (reset='1') then
--          r_reg <= (others=>'0');
--       elsif (clk'event and clk='1') then
--          r_reg <= r_next;
--       end if;
--    end process;
--    -- next-state logic
--    r_next <= (others=>'0') when r_reg=49999999 else
--              r_reg + 1;
--    -- output logic
--    sclk <= '0' when r_reg < 25000000 else
--            '1';
--    -- second divider
--    process(sclk,reset)
--    begin
--       if (reset='1') then
--          s_reg <= (others=>'0');
--       elsif (sclk'event and sclk='1') then
--          s_reg <= s_next;
--       end if;
--    end process;
--    -- next-state logic
--    s_next <= (others=>'0') when s_reg=59 else
--              s_reg + 1;
--    -- output logic
--    mclk <= '0' when s_reg < 30 else
--            '1';
--    sec <= std_logic_vector(s_reg);
--    -- minute divider
--    process(mclk,reset)
--    begin
--       if (reset='1') then
--          m_reg <= (others=>'0');
--       elsif (mclk'event and mclk='1') then
--          m_reg <= m_next;
--       end if;
--    end process;
--    -- next-state logic
--    m_next <= (others=>'0') when m_reg=59 else
--              m_reg + 1;
--    -- output logic
--    min <= std_logic_vector(m_reg);
-- end multi_clock_arch;


----=============================
---- Listing 9.6
----=============================
architecture single_clock_arch of timer is
--  signal r_reg: unsigned(13 downto 0);
--  signal r_next: unsigned(13 downto 0);
  signal sU_reg, sT_reg: unsigned(3 downto 0);
  signal sU_next, sT_next: unsigned(3 downto 0);
  signal mU_next, mT_next: unsigned(3 downto 0);
  signal MU_reg, MT_reg: unsigned(3 downto 0);
  signal s_en, m_en: std_logic;
  -- LFSR
  signal LFSR_reg: unsigned(13 downto 0);
  signal LFSR_next: unsigned(13 downto 0);
  signal fb: std_logic;
  -- SEMENTE
  constant SEED: unsigned(13 downto 0):= to_unsigned(1,14);
  constant CONST_RESET: unsigned(13 downto 0):=to_unsigned(16373,14);
begin
  -- register
  process(clk,reset,sU_reg,sT_reg,mU_reg,mT_reg)
  begin
     if (reset='1') then
		  LFSR_reg <= SEED;
--        r_reg    <= (others=>'0');
		  sU_reg   <= (others=>'0');
		  sT_reg   <= (others=>'0');
		  mT_reg   <= (others=>'0');
		  mU_reg   <= (others=>'0');
     elsif (clk'event and clk='1') then
	     LFSR_reg <= LFSR_next;
--        r_reg    <= r_next;
        sU_reg   <= sU_next;
		  sT_reg   <= sT_next;
        mT_reg   <= mT_next;
		  mU_reg   <= mU_next;
     end if;
	  
--	  if (r_reg = 9999) then 
--		r_next <= (others=>'0');
--	  else 
--			r_next <= r_reg + 1;
--	  end if;
--	  
--	  if (r_reg = 9999) then 
--			s_en <= '1';
--	  else 
--			s_en <= '0';
--	  end if;
	
	  if(LFSR_reg = CONST_RESET) then
			LFSR_next <= SEED;
			s_en <= '1';
	  else
	      LFSR_next <= fb & LFSR_reg(13 downto 1);
			s_en <= '0';
	  end if;

	  
	  if (sU_reg = 9 and s_en = '1') then 
			sU_next <= (others=>'0');
	  elsif (s_en='1') then
			sU_next <= sU_reg + 1;
	  else 
			sU_next <= sU_reg;
	  end if;
	 
	 
	  if (sT_reg=5 and sU_reg=9 and s_en='1') then 
			sT_next <= (others=>'0');
	  elsif (sU_reg=9 and s_en='1') then
			sT_next <= sT_reg + 1;
	  else 
			sT_next <= sT_reg;
	  end if; 			 
	 
	 
	  if (sT_reg=5 and sU_reg=9 and s_en='1') then 
			m_en <= '1';
	  else 
			m_en <= '0';
	  end if;					
				
				
	  if (mU_reg=9 and m_en='1') then 
			mU_next <= (others=>'0');
	  elsif (m_en='1') then
			mU_next <= mU_reg + 1 ;
	  else 
			mU_next <= mU_reg;
	  end if; 				 

	  
	  if (mT_reg=5 and mU_reg=9 and m_en='1') then 
			mT_next <= (others=>'0');
	  elsif (m_en='1') then
			mT_next <= mT_reg + 1 ;
	  else 
			mT_next <= mT_reg;
	  end if;   
	  
  end process;
  
-- BITS[0,2,4,13] = TAPS[13,11,9,0]
  fb <= LFSR_reg(13) xor LFSR_reg(11) xor LFSR_reg(9) xor LFSR_reg(0);
  
  -- output logic
  secT <= std_logic_vector(sT_reg);
  secU <= std_logic_vector(sU_reg);
  minT <= std_logic_vector(mT_reg);
  minU <= std_logic_vector(mU_reg);
  
end single_clock_arch;