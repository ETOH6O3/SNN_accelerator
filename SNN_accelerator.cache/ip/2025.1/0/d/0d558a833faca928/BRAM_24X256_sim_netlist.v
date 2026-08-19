// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Mon Aug 17 14:06:41 2026
// Host        : HUASHUO_U9_smm running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ BRAM_24X256_sim_netlist.v
// Design      : BRAM_24X256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "BRAM_24X256,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [23:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [23:0]dina;
  wire [23:0]doutb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [23:0]NLW_U0_douta_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "1" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.35015 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "BRAM_24X256.mem" *) 
  (* C_INIT_FILE_NAME = "BRAM_24X256.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "24" *) 
  (* C_READ_WIDTH_B = "24" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "NONE" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "READ_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[23:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[23:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20320)
`pragma protect data_block
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
YYa7OKFgiMD0FgVPen5XuXesYX+BtqKCHc52YQ==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
