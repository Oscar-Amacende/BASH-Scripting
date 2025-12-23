#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Uso: $0 archivo.vhd"
    exit 1
fi

ARCHIVO=$1
ENTIDAD=$(grep -i "entity" "$ARCHIVO" | head -n 1 | awk '{print $2}')

TB="tb_${ENTIDAD}.vhd"

echo "🔍 Entidad detectada: $ENTIDAD"
echo "🧪 Generando testbench: $TB"

# ==========================
# Generar testbench
# ==========================
cat > $TB << EOF
library ieee;
use ieee.std_logic_1164.all;

entity tb_$ENTIDAD is
end tb_$ENTIDAD;

architecture sim of tb_$ENTIDAD is

    component $ENTIDAD
        port(
            clk   : in  std_logic;
            reset : in  std_logic;
            rojo  : out std_logic;
            verde : out std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    signal rojo  : std_logic;
    signal verde : std_logic;

begin

    uut: $ENTIDAD
        port map (
            clk   => clk,
            reset => reset,
            rojo  => rojo,
            verde => verde
        );

    clk <= not clk after 10 ns;

    process
    begin
        reset <= '1';
        wait for 30 ns;
        reset <= '0';
        wait for 200 ns;
        wait;
    end process;

end sim;
EOF

echo "✅ Testbench generado"

# ==========================
# Compilación con GHDL
# ==========================
echo "⚙️ Compilando..."

ghdl -a $ARCHIVO || exit 1
ghdl -a $TB || exit 1
ghdl -e tb_$ENTIDAD || exit 1

echo "▶️ Simulando..."
ghdl -r tb_$ENTIDAD --vcd=wave.vcd

echo "📈 Simulación completa"
echo "📂 Archivo de ondas: wave.vcd"
