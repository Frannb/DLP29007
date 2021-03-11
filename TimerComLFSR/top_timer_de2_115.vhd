library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_timer_de2_115 is
  port (
    CLOCK_50 : in std_logic;
    KEY      : in std_logic_vector (0 downto 0);
    HEX0     : out std_logic_vector (6 downto 0);
    HEX1     : out std_logic_vector (6 downto 0);
    HEX2     : out std_logic_vector (6 downto 0);
    HEX3     : out std_logic_vector (6 downto 0)
  );

end entity;

architecture top_a3_2019_2 of top_timer_de2_115 is

  component timer
    port (
		clk, reset: in std_logic;
		secU, secT: out std_logic_vector(3 downto 0);
      minU, minT: out std_logic_vector(3 downto 0)
    );
  end component;

  component bin2bcd is
    generic (N : positive := 16);
    port (
      clk, reset                   : in std_logic;
      binary_in                    : in std_logic_vector(N - 1 downto 0);
      bcd0, bcd1, bcd2, bcd3, bcd4 : out std_logic_vector(3 downto 0)
    );
  end component;

  component bcd2ssd
    port (
      BCD : in std_logic_vector (3 downto 0);
      SSD : out std_logic_vector (6 downto 0)
    );
  end component;

  signal minT, minU : std_logic_vector(3 downto 0);
  signal secT, secU : std_logic_vector(3 downto 0);
  signal min, sec         : std_logic_vector(5 downto 0);
  signal r_reg, r_next    : unsigned(13 downto 0);
  signal reset            : std_logic;

begin

  reset <= not KEY(0);

  t0 : timer
  port map(
    clk   => CLOCK_50,
    reset => reset,
	 secU  => secU,
    secT  => secT,
	 minU  => minU,
	 minT  => minT);

  bcd0 : bcd2ssd
  port map(
    BCD => secU,
    SSD => HEX0);

  bcd1 : bcd2ssd
  port map(
    BCD => secT,
    SSD => HEX1);

  bcd2 : bcd2ssd
  port map(
    BCD => minU,
    SSD => HEX2);

  bcd3 : bcd2ssd
  port map(
    BCD => minT,
    SSD => HEX3);

end top_a3_2019_2;